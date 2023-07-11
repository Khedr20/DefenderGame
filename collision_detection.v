module collision_detection (
    input wire clk,
    input wire reset,
    input wire [9:0] bullet_x, bullet_y, // Bullet position
    input wire bullet_active_in, // Current active state of bullet
    output wire bullet_active_out, // Updated active state of bullet
    input wire [9:0] alien_x, alien_y, // Alien position
    input wire alien_active_in, // Current active state of the alien
    output wire alien_active_out, // Updated active state of the alien
    input wire [9:0] size // Size of bullet and alien
);

    // Collision detection
    reg [9:0] diff_x, diff_y;
    wire hit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, set all active states to 0
            bullet_active_out <= 0;
            alien_active_out <= 0;
        end else begin
            // Check for collision between the active bullet and the alien
            bullet_active_out <= bullet_active_in;
            alien_active_out <= alien_active_in;
            if (bullet_active_in && alien_active_in) begin
                // Calculate absolute difference in x and y coordinates
                diff_x = bullet_x > alien_x ? bullet_x - alien_x : alien_x - bullet_x;
                diff_y = bullet_y > alien_y ? bullet_y - alien_y : alien_y - bullet_y;
                // Check if bullet is within the bounds of the alien
                hit = (diff_x < size && diff_y < size) ? 1'b1 : 1'b0;
                if (hit) begin
                    // Collision detected, set bullet and alien to inactive
                    bullet_active_out <= 0;
                    alien_active_out <= 0;
                end 
            end
        end
    end

endmodule

