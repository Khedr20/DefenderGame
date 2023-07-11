module ship_controller (
    input wire clk,
    input wire reset,
    input wire [1:0] sw_move, // move up/down
    input wire sw_fire, // fire
    input wire hit_detected, // hit detection
    output wire [9:0] o_ship_x, // ship horizontal position
    output wire [9:0] o_ship_y, // ship vertical position
    output reg fire,
    output reg [3:0] lives // output lives left, assuming 3 lives to start
);

    localparam SHIP_SPEED = 100000;
    reg [31:0] cooldown_counter = 0; // Counter for collision cooldown
    localparam COOLDOWN_TIME = 500000; // Cooldown time in number of clock cycles

    localparam IDLE = 2'b00,
               ACTIVE = 2'b01,
               HIT = 2'b10;

    reg [31:0] speed_counter = 0;
    reg [9:0] r_ship_x;
    reg [9:0] r_ship_y;
    reg [1:0] r_state;
    reg [1:0] next_state;
    reg [3:0] r_lives; // Register to hold lives

    // Screen size parameters
    localparam Pos_X_Max = 774;
    localparam Pos_X_Min = 153;
    localparam Pos_Y_Max = 485;
    localparam Pos_Y_Min = 65;

    initial begin
        r_ship_x = 272;
        r_ship_y = 273;
        fire = 0;
        r_lives = 4'd6; // Start with 3 lives
        cooldown_counter = 0; // initialize cooldown counter
    end

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_state <= IDLE;
            cooldown_counter <= 0;
				r_ship_x = 272;
				r_ship_y = 273;
				r_lives = 4'd6;
        end else begin
            r_state <= next_state;

            if (cooldown_counter > 0)
                cooldown_counter <= cooldown_counter - 1;

            case(r_state)
                IDLE:
                begin
                    if(sw_move != 2'b00)
                        next_state <= ACTIVE;
                end
                
                ACTIVE:
                begin
                    if(hit_detected && cooldown_counter == 0) begin
                        next_state <= HIT;
                        cooldown_counter <= COOLDOWN_TIME; // reset cooldown timer after a hit
                    end
                    else if(speed_counter == SHIP_SPEED) begin
                        if (sw_move == 2'b01 && r_ship_y > Pos_Y_Min)
                            r_ship_y <= r_ship_y - 1;
                        if (sw_move == 2'b10 && r_ship_y < Pos_Y_Max)
                            r_ship_y <= r_ship_y + 1;
                        fire <= sw_fire;
                        speed_counter <= 0;
                    end else
                        speed_counter <= speed_counter + 1;
                end

                HIT:
                begin
                    if(r_lives > 0) begin
                        r_ship_x <= 272;
                        r_ship_y <= 273;
                        r_lives <= r_lives - 1;
                    end
                    next_state <= IDLE;
                end
                
                default: next_state <= IDLE;
            endcase
        end
    end

    assign o_ship_x = r_ship_x;
    assign o_ship_y = r_ship_y;
    assign lives = r_lives;
endmodule
