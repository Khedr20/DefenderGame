module control_unit (
    input wire clk,
    input wire reset,
    input wire [2:0] lives,
    output reg LED
);
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            LED <= 1'b0;
        end
        else begin
            if(lives == 3'b000) 
                LED <= 1'b1;    // Game Over, Light up the LED
            else
                LED <= 1'b0;    // Game is still on, keep the LED off
        end
    end
endmodule
