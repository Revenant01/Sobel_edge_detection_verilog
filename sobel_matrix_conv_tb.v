`timescale 1ns / 1ps

module sobel_matrix_conv_tb;

  // Parameters
  parameter data_size = 24; // Pixel size (RGB: 8 bits each)
  parameter output_size = 29; // Output size from the module

  // Inputs
  reg clk;
  reg [data_size-1:0] in_p1a, in_p2, in_p1b; // Top row inputs
  reg [data_size-1:0] in_m1a, in_m2, in_m1b; // Bottom row inputs

  // Output
  wire [output_size-1:0] data_out;

  // Instantiate the sobel_matrix_conv module
  sobel_matrix_conv #(
    .data_size(data_size)
  ) uut (
    .clk(clk),
    .in_p1a(in_p1a),
    .in_p2(in_p2),
    .in_p1b(in_p1b),
    .in_m1a(in_m1a),
    .in_m2(in_m2),
    .in_m1b(in_m1b),
    .data_out(data_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Task to check output against expected value
  task check_output;
    input [31:0] test_id;
    input [output_size-1:0] expected;
    begin
      if (data_out === expected)
        $display("Test %d PASSED: Data_out = %d", test_id, $signed(data_out));
      else
        $display("Test %d FAILED: Expected = %d, Got = %d", test_id, $signed(expected), $signed(data_out));
    end
  endtask


  // Testbench logic
  initial begin
    // Initialize inputs
    clk = 0;
    in_p1a = 0; in_p2 = 0; in_p1b = 0;
    in_m1a = 0; in_m2 = 0; in_m1b = 0;

    // Wait for reset stabilization
    #10;

    //TEST 1
    in_p1a = 24'h000009; 
    in_p2  = 24'h000006;
    in_p1b = 24'h000008;
    in_m1a = 24'h00000A;
    in_m2  = 24'h000000;
    in_m1b = 24'h000005;
    #10;
    check_output(0, 14); // Expected output = 14

    //TEST 2
    in_p1a = 24'h000004; 
    in_p2  = 24'h000002;
    in_p1b = 24'h000004;
    in_m1a = 24'h000009;
    in_m2  = 24'h000006;
    in_m1b = 24'h000009;
    #10;
    check_output(1, -18); // Expected output = -18


    //TEST 3
    in_p1a = 24'h000000; 
    in_p2  = 24'h000002;
    in_p1b = 24'h000003;
    in_m1a = 24'h000009;
    in_m2  = 24'h000006;
    in_m1b = 24'h000008;
    #10;
    check_output(2, -22); // Expected output = -22

    //TEST 4
    in_p1a = 24'h000006; 
    in_p2  = 24'h000008;
    in_p1b = 24'h000005;
    in_m1a = 24'h000000;
    in_m2  = 24'h000005;
    in_m1b = 24'h000007;
    #10;
    check_output(3, 10); // Expected output = 10


    //TEST 5
    in_p1a = 24'h000002; 
    in_p2  = 24'h000004;
    in_p1b = 24'h000004;
    in_m1a = 24'h000006;
    in_m2  = 24'h000009;
    in_m1b = 24'h000005;
    #10;
    check_output(4, -15); // Expected output = -15


    //TEST 6
    in_p1a = 24'h000002; 
    in_p2  = 24'h000003;
    in_p1b = 24'h000003;
    in_m1a = 24'h000006;
    in_m2  = 24'h000008;
    in_m1b = 24'h000005;
    #10;
    check_output(5, -16); // Expected output = -16

    //TEST 7
    in_p1a = 24'h000008; 
    in_p2  = 24'h000005;
    in_p1b = 24'h000008;
    in_m1a = 24'h000005;
    in_m2  = 24'h000007;
    in_m1b = 24'h000008;
    #10;
    check_output(6, -1); // Expected output = -1

    //TEST 8
    in_p1a = 24'h000004; 
    in_p2  = 24'h000004;
    in_p1b = 24'h000005;
    in_m1a = 24'h000009;
    in_m2  = 24'h000005;
    in_m1b = 24'h00000A;
    #10;
    check_output(7, -12); // Expected output = -12

    //TEST 9
    in_p1a = 24'h000003; 
    in_p2  = 24'h000003;
    in_p1b = 24'h000000;
    in_m1a = 24'h000008;
    in_m2  = 24'h000005;
    in_m1b = 24'h000008;
    #10;
    check_output(8, -17); // Expected output = -17

    // End of simulation
    $stop;
  end

endmodule
