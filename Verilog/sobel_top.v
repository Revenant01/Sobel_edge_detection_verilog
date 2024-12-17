module sobel_top #(
    parameter data_size = 24,  // Pixel data size (RGB)
    parameter window_count = 9, // chnages based on photo size
    localparam window_size = 9, // This one must not be changed
    parameter conv_out_data_size = 29, //Fixed
    parameter sqrt_in_data_size = 60, // The sum of squares of two 29-bit numbers requires 60 bits to represent the result: (value1^2 + value2^2)
    parameter sqrt_out_data_size = sqrt_in_data_size / 2
) (
    input clk,
    input reset,
    output done
);

  // Signals 
  wire [data_size-1:0] in_p1a_x_w, in_p2_x_w, in_p1b_x_w;
  wire [data_size-1:0] in_m1a_x_w, in_m2_x_w, in_m1b_x_w;

  wire [data_size-1:0] in_p1a_y_w, in_p2_y_w, in_p1b_y_w;
  wire [data_size-1:0] in_m1a_y_w, in_m2_y_w, in_m1b_y_w;

  // Outputs from sobel_matrix_conv
  wire [conv_out_data_size-1:0] data_out_x_w;  
  wire [conv_out_data_size-1:0] data_out_y_w;

  // Indicates valid input data from the controller
  wire valid_data_w;  
  wire conv_ready_x_w;
  wire conv_ready_y_w;

  wire [sqrt_in_data_size-1 : 0] sqrt_num_w;
  wire [sqrt_out_data_size-1 : 0] sqrt_sq_w;

  // Controller instantiation
  controller #(
      .data_size(data_size),
      .window_count(window_count),
      .window_size(window_size),
      .conv_out_data_size(conv_out_data_size),
      .sqrt_in_data_size(sqrt_in_data_size),
      .sqrt_out_data_size(sqrt_out_data_size)
  ) controller_inst (
      .clk(clk),
      .reset(reset),
      .valid_data(valid_data_w),
      .in_p1a_x(in_p1a_x_w),
      .in_p2_x(in_p2_x_w),
      .in_p1b_x(in_p1b_x_w),
      .in_m1a_x(in_m1a_x_w),
      .in_m2_x(in_m2_x_w),
      .in_m1b_x(in_m1b_x_w),
      .in_p1a_y(in_p1a_y_w),
      .in_p2_y(in_p2_y_w),
      .in_p1b_y(in_p1b_y_w),
      .in_m1a_y(in_m1a_y_w),
      .in_m2_y(in_m2_y_w),
      .in_m1b_y(in_m1b_y_w),
      .conv_ready_x(conv_ready_x_w),
      .conv_ready_y(conv_ready_y_w),
      .edge_data_in_x(data_out_x_w),
      .edge_data_in_y(data_out_y_w),
      .edge_data_out(edge_data_out),
      .sqrt_num(sqrt_num_w),  //output
      .sqrt_sq(sqrt_sq_w),  // input
      .done(done)
  );

  // Sobel matrix convolution instantiation
  sobel_matrix_conv #(
      .data_size(data_size),
      .conv_out_data_size(conv_out_data_size)
  ) sobel_inst_x (
      .clk(clk),
      .valid_data(valid_data_w),
      .in_p1a(in_p1a_x_w),
      .in_p2(in_p2_x_w),
      .in_p1b(in_p1b_x_w),
      .in_m1a(in_m1a_x_w),
      .in_m2(in_m2_x_w),
      .in_m1b(in_m1b_x_w),
      .conv_ready(conv_ready_x_w),
      .data_out(data_out_x_w)
  );

  sobel_matrix_conv #(
      .data_size(data_size),
      .conv_out_data_size(conv_out_data_size)
  ) sobel_inst_y (
      .clk(clk),
      .valid_data(valid_data_w),
      .in_p1a(in_p1a_y_w),
      .in_p2(in_p2_y_w),
      .in_p1b(in_p1b_y_w),
      .in_m1a(in_m1a_y_w),
      .in_m2(in_m2_y_w),
      .in_m1b(in_m1b_y_w),
      .conv_ready(conv_ready_y_w),
      .data_out(data_out_y_w)
  );

  sqrt #(
      .WIDTH(sqrt_in_data_size),
      .OUT_WIDTH(sqrt_out_data_size)
  ) sqrt_inst (
      .num(sqrt_num_w),  // Input number
      .sqr(sqrt_sq_w)    // Output square root
  );

endmodule
