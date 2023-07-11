module collision_detection(
    input wire clk,
    input wire reset,
    input wire [9:0] ship_x,
    input wire [9:0] ship_y,
    input wire [9:0] bullet_x [0:9],
    input wire [9:0] bullet_y [0:9],
    input wire [9:0] alien_x [0:9],
    input wire [9:0] alien_y [0:9],
    output reg [2:0] lives,
    output reg [9:0] score,
    output reg game_over,
    output reg you_won
);

    reg [9:0] prev_ship_x;
    reg [9:0] prev_ship_y;
    reg [9:0] prev_bullet_x [0:9];
    reg [9:0] prev_bullet_y [0:9];
    reg [9:0] prev_alien_x [0:9];
    reg [9:0] prev_alien_y [0:9];
    
    reg [9:0] collided_bullet;
    reg [9:0] collided_alien;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lives <= 3;
            score <= 0;
            game_over <= 0;
            you_won <= 0;
            prev_ship_x <= 0;
            prev_ship_y <= 0;
            prev_bullet_x <= 0;
            prev_bullet_y <= 0;
            prev_alien_x <= 0;
            prev_alien_y <= 0;
            collided_bullet <= 0;
            collided_alien <= 0;
        end else begin
            // Collision detection between ship and alien
            for (int i = 0; i < 10; i = i + 1) begin
                if (prev_ship_x == alien_x[i] && prev_ship_y == alien_y[i]) begin
                    lives <= lives - 1;
                    collided_alien <= i;
                end
            end
            
            // Collision detection between bullet and alien
            for (int i = 0; i < 10; i = i + 1) begin
                for (int j = 0; j < 10; j = j + 1) begin
                    if (prev_bullet_x[i] == alien_x[j] && prev_bullet_y[i] == alien_y[j]) begin
                        score <= score + 50;
                        collided_bullet <= i;
                        collided_alien <= j;
                    end
                end
            end
            
            // Update previous positions
            prev_ship_x <= ship_x;
            prev_ship_y <= ship_y;
            prev_bullet_x <= bullet_x;
            prev_bullet_y <= bullet_y;
            prev_alien_x <= alien_x;
            prev_alien_y <= alien_y;
            
            // Game over condition
            if (lives == 0) begin
                game_over <= 1;
                you_won <= 0;
            end else if (score >= 1000) begin
                game_over <= 1;
                you_won <= 1;
            end else begin
                game_over <= 0;
                you_won <= 0;
            end
        end
    end
endmodule
