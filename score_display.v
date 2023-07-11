module score_display(
    input [15:0] score, // 4 digit score
    output reg [6:0] seg0, seg1, seg2, seg3 // 7 segment outputs for each digit
);

    reg [3:0] digit0, digit1, digit2, digit3;

    always @(*) begin
        // Split the 4 digit score into individual digits
        digit0 = score[3:0]; // Units
        digit1 = score[7:4]; // Tens
        digit2 = score[11:8]; // Hundreds
        digit3 = score[15:12]; // Thousands

        seg0 = bcd_to_seg(digit0);
        seg1 = bcd_to_seg(digit1);
        seg2 = bcd_to_seg(digit2);
        seg3 = bcd_to_seg(digit3);
    end

    function [6:0] bcd_to_seg; // BCD to 7-segment decoder function
        input [3:0] bcd;
        begin
            case(bcd)
						4'b0000: bcd_to_seg = 7'b1000000; // 0
						4'b0001: bcd_to_seg = 7'b1111001; // 1
						4'b0010: bcd_to_seg = 7'b0100100; // 2
						4'b0011: bcd_to_seg = 7'b0110000; // 3
						4'b0100: bcd_to_seg = 7'b0011001; // 4
						4'b0101: bcd_to_seg = 7'b0010010; // 5
						4'b0110: bcd_to_seg = 7'b0000010; // 6
						4'b0111: bcd_to_seg = 7'b1111000; // 7
						4'b1000: bcd_to_seg = 7'b0000000; // 8
						4'b1001: bcd_to_seg = 7'b0011000; // 9
                  default: bcd_to_seg = 7'b1111111; // Off state
            endcase
        end
    endfunction

endmodule
