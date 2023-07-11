module draw_square (
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);

parameter X_START = 100;
parameter Y_START = 100;
parameter SIZE = 100;

always @* begin
    if ((x >= X_START) && (x < X_START + SIZE) && (y >= Y_START) && (y < Y_START + SIZE)) begin
        red = 8'b0;
        green = 8'b11111111;
        blue = 8'b0;
    end else begin
        red = 8'b0;
        green = 8'b0;
        blue = 8'b0;
    end
end

endmodule
