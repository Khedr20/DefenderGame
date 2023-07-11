module lives_display (
    input [7:0] input_value,
    output reg [7:0] output_value
);
  
  always @(*) begin
    case (input_value)
      1: output_value = 8'b00000001;
      2: output_value = 8'b00000001;
      3: output_value = 8'b00000011;
      4: output_value = 8'b00000011;
      5: output_value = 8'b00000111;
      6: output_value = 8'b00000111;
      7: output_value = 8'b01111111;
      8: output_value = 8'b11111111;
      // Add more cases as needed
      default: output_value = 8'b00000000;
    endcase
  end

endmodule