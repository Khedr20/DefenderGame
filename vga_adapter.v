module vga_controller(
	input wire clk,
	output wire VGA_HS,
	output wire VGA_VS,
	output wire VGA_BLANK,
	output wire VGA_SYNC
);

	// VGA Controller Constants for 640x480 @60Hz
	localparam H_SYNC_CYCLES = 96;
	localparam H_BACK_PORCH = 48;
	localparam H_ACTIVE = 640;
	localparam H_FRONT_PORCH = 16;
	localparam TOTAL_H_CYCLES = 800;

	localparam V_SYNC_CYCLES = 2;
	localparam V_BACK_PORCH = 33;
	localparam V_ACTIVE = 480;
	localparam V_FRONT_PORCH = 10;
	localparam TOTAL_V_CYCLES = 525;

	localparam SQUARE_SIZE = 50;
	localparam X_POSITION = 320; // middle of screen
	localparam Y_POSITION = 240; // middle of screen

	localparam BULLET_WIDTH = 1;
	localparam BULLET_HEIGHT = 5;

	reg [9:0] h_count = 0; 
	reg [9:0] v_count = 0;
	wire active_video;

	wire	clrvidh = (h_count <= 800) ? 1'b0 : 1'b1;
	wire  	clrvidv = (v_count <= 525) ? 1'b0 : 1'b1;
	assign active_video = (v_count > 35 && v_count < 515 && h_count > 143 && h_count < 784)? 1'b1 : 1'b0;

	assign VGA_HS = (h_count < H_SYNC_CYCLES) ? 0 : 1;
	assign VGA_VS = (v_count < V_SYNC_CYCLES) ? 0 : 1;

	assign VGA_BLANK = ~active_video;
	assign VGA_SYNC = ~(VGA_HS && VGA_VS);

	always @ (posedge clk) begin 
		// Horizontal Counter
		if (h_count >= TOTAL_H_CYCLES - 1) begin // At pixel 800
			h_count <= 0; // Reset counter
		end else begin
			h_count <= h_count + 1; // Else increment counter
		end
	end

	always @ (posedge clk) begin 
		// Vertical Counter
		if (v_count >= TOTAL_V_CYCLES - 1) begin // At pixel 525 for vertical
			v_count <= 0; // Reset counter
		end else begin
			if (h_count >= TOTAL_H_CYCLES - 1) begin // Else increment vertical counter, when at end of horizontal counter
				v_count <= v_count + 1; 
			end
		end
	end

endmodule
