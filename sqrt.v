module sqrt #(
    parameter WIDTH = 32,
    parameter OUT_WIDTH = 16
) (
    input      [    WIDTH-1:0] num,  // Input number
    output reg [OUT_WIDTH-1:0] sqr   // Output square root
);

  reg [WIDTH-1:0] a;
  reg [OUT_WIDTH-1:0] q;
  reg [OUT_WIDTH+1:0] left, right, r;
  integer i;

  always @(*) begin
    // Initialize all variables.
    a = num;
    q = 0;
    left = 0;
    right = 0;
    r = 0;

    // Perform square root calculation.
    for (i = 0; i < OUT_WIDTH; i = i + 1) begin
      right = {q, r[OUT_WIDTH+1], 1'b1};
      left = {r[OUT_WIDTH-1:0], a[WIDTH-1:WIDTH-2]};
      a = {a[WIDTH-3:0], 2'b00};  // Left shift by 2 bits.
      if (r[OUT_WIDTH+1] == 1)  // Add if r is negative
        r = left + right;
      else  // Subtract if r is positive
        r = left - right;
      q = {q[OUT_WIDTH-2:0], !r[OUT_WIDTH+1]};
    end

    sqr <= q;  // Final assignment to output.
  end

endmodule
