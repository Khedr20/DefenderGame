module bullet_controller (
    input wire clk,
    input wire reset,
    input wire fire, // Fire signal from ship_controller
    input wire hit_detected, // Hit detection signal
    input wire [9:0] ship_x, ship_y, // Position of the ship
    output wire [9:0] o_bullet_x, o_bullet_y, // Bullet position
    output wire bullet_active, // Indicates whether the bullet is currently active
    output wire [15:0] scores // output lives left, assuming 3 lives to start
);

    localparam BULLET_SPEED = 55000;
    localparam RELOAD_SPEED = 50000;

    localparam IDLE = 2'b00,
               FIRING = 2'b01,
               HIT = 2'b10;

    reg [31:0] speed_counter = 0;
    reg [31:0] reload_counter = 0;
    reg [9:0] r_bullet_x;
    reg [9:0] r_bullet_y;
    reg r_bullet_active = 0;
    reg [1:0] r_state;
    reg [1:0] next_state;
    reg [15:0] r_scores = 0;

    always @(posedge clk) begin
        if(reset) begin
            r_state <= IDLE;
            r_scores <= 0;
        end else begin
            r_state <= next_state;
            case(r_state)
                IDLE:
                begin
                    if(fire && reload_counter == RELOAD_SPEED) begin
                        r_bullet_x <= ship_x;
                        r_bullet_y <= ship_y;
                        r_bullet_active <= 1;
                        reload_counter <= 0;
                        next_state <= FIRING;
                    end else if(reload_counter != RELOAD_SPEED)
                        reload_counter <= reload_counter + 1;
                end
                
                FIRING:
                begin
                    if(hit_detected)
                        next_state <= HIT;
                    else if(speed_counter == BULLET_SPEED) begin
                        r_bullet_x <= r_bullet_x + 1;
                        r_bullet_active <= 1;
                        if(r_bullet_x >= 774) begin
                            r_bullet_active <= 0;
                            next_state <= IDLE;
                        end
                        speed_counter <= 0;
                    end else
                        speed_counter <= speed_counter + 1;
                end

                HIT:
                begin
                    r_bullet_active <= 0;
                    r_scores <= r_scores + 5;
                    next_state <= IDLE;
                end
                
                default: next_state <= IDLE;
            endcase
        end
    end

    assign o_bullet_x = r_bullet_x;
    assign o_bullet_y = r_bullet_y;
    assign bullet_active = r_bullet_active;
    assign scores = r_scores;
endmodule
