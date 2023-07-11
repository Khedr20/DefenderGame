module RandomNumberGenerator (
  input wire clk,
  input wire reset,
  input wire [31:0] a,
  input wire [31:0] b,
  output reg [31:0] rando
);

  reg [31:0] lfsr_state;

  always @(posedge clk) begin
    if (reset)
      lfsr_state <= 32'h00FF;
    else
      lfsr_state <= {lfsr_state[30:0], lfsr_state[0] ^ lfsr_state[1]};
  end

  always @(*) begin
    if (a < b)
      rando = a + lfsr_state % (b - a + 1);
    else
      rando = b + lfsr_state % (a - b + 1);
  end

endmodule
