`timescale 1ns/1ps

module sqrt_tb;

    reg [31:0] num;  // Test input
    wire [15:0] sqr; // Test output

    // Instantiate the sqrt module
    sqrt uut (
        .num(num),
        .sqr(sqr)
    );

    // Simulation - Apply inputs.
    initial begin
        $display("Time\tInput\t\tOutput");
        $monitor("%0t\t%d\t\t%d", $time, num, sqr);

        num = 32'd232;    #10;
        num = 32'd328;      #10;
        num = 32'd488;         #10;
        num = 32'd116;  #10;
        num = 32'd226;         #10;
        num = 32'd272;       #10;
        num = 32'd26;     #10;
        num = 32'd148; #10;
        num = 32'd290; #10;
        $stop;
    end

endmodule
