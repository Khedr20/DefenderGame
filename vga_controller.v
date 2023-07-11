module vga_controller (
    input  CLK, // 50 MHz input clock
    output [9:0] H_COUNT, V_COUNT, // Horizontal and vertical counters
    output VGA_HS, VGA_VS, // Horizontal and vertical sync signals
    output VGA_BLANK_N, VGA_SYNC_N // Blank and sync signals
);

    // Parameters for 640x480 @ 60Hz
    parameter H_SYNC_CYCLES = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_ACTIVE_VIDEO_MIN = 143;
	 parameter H_ACTIVE_VIDEO_MAX = 784;
    parameter H_FRONT_PORCH = 16;
    parameter H_TOTAL_CYCLES = 800;

    parameter V_SYNC_CYCLES = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_ACTIVE_VIDEO_MIN = 35;
	 parameter V_ACTIVE_VIDEO_MAX = 515;
    parameter V_FRONT_PORCH = 10;
    parameter V_TOTAL_CYCLES = 525;

    // Counter for horizontal pixels
    reg [9:0] h_count = 0;
    always @(posedge CLK) begin
        if (h_count == H_TOTAL_CYCLES) h_count <= 0;
        else h_count <= h_count + 1;
    end

    // Counter for vertical pixels
    reg [9:0] v_count = 0;
    always @(posedge CLK) begin
        if (v_count == V_TOTAL_CYCLES) v_count <= 0;
        else if (h_count == H_TOTAL_CYCLES-1) v_count <= v_count + 1;
    end

    // Generate VGA signals
    assign VGA_HS = (h_count < H_SYNC_CYCLES) ? 1'b1 : 1'b0;
    assign VGA_VS = (v_count < V_SYNC_CYCLES) ? 1'b1 : 1'b0;
    assign VGA_BLANK_N = ((h_count > H_ACTIVE_VIDEO_MIN) && (h_count < H_ACTIVE_VIDEO_MAX) && (v_count > V_ACTIVE_VIDEO_MIN) && (v_count < V_ACTIVE_VIDEO_MAX)) ? 1'b1 : 1'b0;
//    assign VGA_SYNC_N = ((h_count < H_SYNC_CYCLES) || (v_count < V_SYNC_CYCLES)) ? 1'b1 : 1'b0;
    assign H_COUNT = h_count;
    assign V_COUNT = v_count;

endmodule
