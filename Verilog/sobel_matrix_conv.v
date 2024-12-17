module sobel_matrix_conv #(
    parameter data_size = 24,
    parameter conv_out_data_size = 29
) (
    input clk,
    input valid_data,
    input [data_size-1 : 0] in_p1a,
    input [data_size-1 : 0] in_p2,
    input [data_size-1 : 0] in_p1b,
    input [data_size-1 : 0] in_m1a,
    input [data_size-1 : 0] in_m2,
    input [data_size-1 : 0] in_m1b,
    output reg conv_ready,
    output reg [conv_out_data_size-1 : 0] data_out
);

  reg signed [conv_out_data_size-1:0] sum; 

  // reg [11:0] lum_p1a, lum_p1b,lum_p2,lum_m1a,lum_m1b,lum_m2; 

  always @(posedge clk) begin
    conv_ready <= 0;
    if (valid_data) begin 
      sum = in_p1a + (in_p2 << 1) + in_p1b - in_m1a - (in_m2 << 1) - in_m1b;
      data_out <= sum;
      conv_ready <= 1;
    end else begin 
      data_out <= 0;
    end

  end

endmodule
