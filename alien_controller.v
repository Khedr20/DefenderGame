module alien_controller #(
    parameter START_X = 673,
    parameter START_Y_MIN = 65,
	 parameter START_Y_MAX = 485
) (
    input wire clk,
    input wire reset,
    input wire hit_detected, // Hit detection signal
    output wire [9:0] o_alien_x, o_alien_y, // Alien position
    output wire alien_active // Indicates whether the alien is currently active
);

    localparam ALIEN_SPEED = 500000;

    localparam IDLE = 2'b00,
               ACTIVE = 2'b01,
               HIT = 2'b10;

    reg [31:0] speed_counter = 0;
    reg [9:0] r_alien_x;
    reg [9:0] r_alien_y;
    reg r_alien_active = 1'b0;
    reg [1:0] r_state;
    reg [1:0] next_state;
	 
	  // Screen size parameters
    localparam Pos_X_Max = 774;
    localparam Pos_X_Min = 153;
    localparam Pos_Y_Max = 485;
    localparam Pos_Y_Min = 65;
	 
    wire [31:0] a = START_Y_MIN;
    wire [31:0] b = START_Y_MAX;
    reg [31:0] randomNum;
	 reg [2:0] random_direction;

    // Instantiate the RandomNumberGenerator module
    RandomNumberGenerator RNG2 (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .rando(randomNum)
    );

    always @(posedge clk) begin
        if(reset) begin
            r_state <= IDLE;
		  end
        else
            r_state <= next_state;
    end

    always @(posedge clk) begin
        next_state <= r_state;

        case(r_state)
            IDLE:
				begin
					  r_alien_x <= START_X; // Start at the right edge of the screen
					  r_alien_y <= randomNum; // Random y-coordinate
					  r_alien_active <= 1'b1;
					  next_state <= ACTIVE;
            end
            
            ACTIVE:
            begin
                if(hit_detected)
                    next_state <= HIT;
                else if(speed_counter == ALIEN_SPEED)
                begin
                    // Move the alien to the left
						  random_direction <= randomNum % 6;
                    r_alien_x <= r_alien_x - 1;
                    case (random_direction)
								3'b000: r_alien_x <= r_alien_x - 1; // Move left
								3'b010: r_alien_y <= r_alien_y - 1; // Move down
								3'b011: r_alien_y <= r_alien_y + 1; // Move up
								3'b100: begin
												r_alien_x <= r_alien_x - 1; // Move left
												r_alien_y <= r_alien_y - 1; // Move down
										  end
								3'b101: begin
												r_alien_x <= r_alien_x - 1; // Move left
												r_alien_y <= r_alien_y + 1; // Move up
										  end
								default: r_alien_x <= r_alien_x - 1;
						  endcase
                    if(r_alien_x <= 153 || r_alien_y <= 65 || r_alien_y >=485) // Alien reached the left edge of the screen
                    begin
                        r_alien_active <= 0;
                        next_state <= IDLE;
                    end
                    speed_counter <= 0;
                end
                else
                    speed_counter <= speed_counter + 1;
            end

            HIT:
            begin
                r_alien_active <= 0;
                next_state <= IDLE;
            end
            
            default: next_state <= IDLE;
        endcase
    end

    assign o_alien_x = r_alien_x;
    assign o_alien_y = r_alien_y;
    assign alien_active = r_alien_active;

endmodule
