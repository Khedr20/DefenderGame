module clock_divider (
    input wire clk_50MHz, // input 50MHz clock
    output reg clk_25MHz  // output 25MHz clock
);
    reg [0:0] clk_div_counter = 0;

    always @(posedge clk_50MHz) begin
        clk_div_counter <= clk_div_counter + 1;
        clk_25MHz <= clk_div_counter[0];
    end
endmodule
