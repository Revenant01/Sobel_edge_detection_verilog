module controller #(
    parameter data_size = 24,
    parameter window_count = 9,
    parameter window_size = 9,
    parameter conv_out_data_size = 29,
    parameter sqrt_in_data_size = 60,
    parameter sqrt_out_data_size = 30
) (
    input clk,
    input reset,
    output reg valid_data,
    output reg [data_size-1:0] in_p1a_x,
    output reg [data_size-1:0] in_p2_x,
    output reg [data_size-1:0] in_p1b_x,
    output reg [data_size-1:0] in_m1a_x,
    output reg [data_size-1:0] in_m2_x,
    output reg [data_size-1:0] in_m1b_x,
    output reg [data_size-1:0] in_p1a_y,
    output reg [data_size-1:0] in_p2_y,
    output reg [data_size-1:0] in_p1b_y,
    output reg [data_size-1:0] in_m1a_y,
    output reg [data_size-1:0] in_m2_y,
    output reg [data_size-1:0] in_m1b_y,
    input [conv_out_data_size-1:0] edge_data_in_x,
    input conv_ready_x,
    input conv_ready_y,
    input [conv_out_data_size-1:0] edge_data_in_y,
    output reg [conv_out_data_size-1:0] edge_data_out,
    output reg [sqrt_in_data_size-1 : 0] sqrt_num,
    input [sqrt_out_data_size-1 : 0] sqrt_sq,
    output reg done
);

  // State transition
  localparam IDLE = 0, READ = 1, CONV = 2, SQRT = 3, MAG = 4, WRTE = 5, DONE = 6;
  reg [3:0] state;

  // File handling
  integer input_file, output_file;
  reg [data_size-1:0] buffer[0:window_size - 1];  // 3x3 sliding window buffer
  integer window_index = 0, delayed_window_index = 0;

  integer i_window = 0;

  // Ix, Iy
  reg [conv_out_data_size-1:0] Ix[0:window_count - 1];
  reg [conv_out_data_size-1:0] Iy[0:window_count - 1];

  // Sqare root
  reg [sqrt_out_data_size-1:0] sq[0:window_count - 1];

  // Magnitude
  reg [sqrt_out_data_size+window_count -1 : 0] sum;
  integer Threshold = 0;
  reg [data_size-1:0] thrs[0:window_count - 1];

  always @(posedge clk or posedge reset) begin : fsm_function
    if (reset) begin
      valid_data <= 0;
      window_index <= 0;
      done <= 0;
      state <= IDLE;
    end else begin
      case (state)

        IDLE: begin
          input_file  <= $fopen("output_pixels.txt", "r");
          output_file <= $fopen("binary_output.txt", "w");
          if (input_file && output_file) begin
            state <= READ;
          end
        end

        READ: begin
          valid_data <= 0;
          if (!$feof(input_file)) begin
            for (i_window = 0; i_window < window_size; i_window = i_window + 1) begin
              $fscanf(input_file, "%b\n", buffer[i_window]);
            end
          end
          state <= CONV;
        end

        CONV: begin
          valid_data <= 1;
          // Assign values from the buffer to the input signals
          {in_p1a_x, in_p2_x, in_p1b_x} <= {buffer[2], buffer[5], buffer[8]};
          {in_m1a_x, in_m2_x, in_m1b_x} <= {buffer[0], buffer[3], buffer[6]};
          {in_p1a_y, in_p2_y, in_p1b_y} <= {buffer[0], buffer[1], buffer[2]};
          {in_m1a_y, in_m2_y, in_m1b_y} <= {buffer[6], buffer[7], buffer[8]};

          // Calculate results for Ix and Iy for the current window
          if (conv_ready_x) Ix[window_index] <= edge_data_in_x;
          if (conv_ready_y) Iy[window_index] <= edge_data_in_y;

          if (conv_ready_x && conv_ready_y) window_index <= window_index + 1;

          if (window_index == window_count - 1) begin
            window_index <= 0;
            valid_data <= 0;
            sum <= 0;
            state <= SQRT;
          end else begin
            state <= READ;
          end
        end

        SQRT: begin

          sqrt_num = (abs(Ix[window_index]) ** 2) + (abs(Iy[window_index]) ** 2);
          sq[delayed_window_index] = sqrt_sq;
          sum <= (window_index == 0) ? 0 : sum + sqrt_sq;

          if (window_index == window_count) begin
            window_index <= 0;
            delayed_window_index <= 0;
            state <= MAG;
          end else begin
            delayed_window_index <= window_index;
            window_index <= window_index + 1;
            state <= SQRT;
          end
        end

        MAG: begin
          //Threshold = rounded_division(sum, window_count);
          Threshold = sum / window_count;
          thrs[delayed_window_index] <= (sq[delayed_window_index] > Threshold) ? 24'h000000 : 24'hffffff;

          if (window_index == window_count) begin
            window_index <= 0;
            delayed_window_index <= 0;
            state <= WRTE;
          end else begin
            delayed_window_index <= window_index;
            window_index <= window_index + 1;
            state <= MAG;
          end
        end

        WRTE: begin
          $fwrite(output_file, "%024b\n",
                  thrs[delayed_window_index]);  // Write each value in the array to the file
          if (window_index == window_count) begin
            window_index <= 0;
            delayed_window_index <= 0;
            state <= DONE;
          end else begin
            delayed_window_index <= window_index;
            window_index <= window_index + 1;
            state <= WRTE;
          end
        end

        DONE: begin
          $fclose(input_file);
          $fclose(output_file);
          done <= 1;
        end

        default: begin
          valid_data <= 0;
          done <= 0;
        end
      endcase
    end
  end


  function [conv_out_data_size-1:0] abs;
    input [conv_out_data_size-1:0] x;
    begin
      if (x[conv_out_data_size-1] == 1)  // Check if x is negative (MSB is 1 for negative numbers)
        abs = ~x + 1;  // Take two's complement to get the positive value
      else abs = x;  // If positive, return the value as is
    end
  endfunction

  function integer rounded_division;
    input [sqrt_out_data_size+window_count-1:0] numerator;  // Replace with your required size
    input integer denominator;
    integer temp;
    begin
      temp = numerator + (denominator >> 1);  // Add half of denominator
      rounded_division = temp / denominator;  // Perform division
    end
  endfunction

endmodule
