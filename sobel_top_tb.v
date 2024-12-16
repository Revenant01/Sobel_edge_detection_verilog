module sobel_top_tb;

  // Testbench signals
  reg clk;
  reg reset;
  wire done;

  // Instantiate the sobel_top module
  sobel_top #(
    .data_size(24),  // Set the data_size parameter
    .conv_out_data_size(29)
  ) uut (
    .clk(clk),
    .reset(reset),
    .done(done)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;  // Clock period of 10 time units
  end

  // Test stimulus
  initial begin
    clk = 0;
    reset = 0;

    #1
    // Apply reset
    reset = 1;  // Assert reset at the first clock cycle
    #2 
    reset = 0; // Deassert reset after two clock cycles

    #600  
    $stop;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0t | clk: %b | reset: %b", $time, clk, reset);
  end

endmodule
