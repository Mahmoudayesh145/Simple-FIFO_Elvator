// this code will represents simple elvator consist of 8 floors from 0 to 7
module Elevator(
    input rst,
    input clk,
    input [2:0] floor_request,
    output reg [2:0] current_floor,
    output reg [2:0] next_floor,
    output reg moving_up,
    output reg moving_down,
    output reg emergency_stop
);
    
    // Internal state variables
    reg [2:0] requested_floors; // 3-bit register to store requested floors
    reg [2:0] target_floor; // 3-bit register to store the target floor


    localparam IDLE = 2'b00;
    localparam MOVING_UP = 2'b01;
    localparam MOVING_DOWN = 2'b10;

    reg [1:0] current_state;
    reg [1:0] next_state;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    initial begin
        current_floor = 3'b000; // Start at floor 0
        next_floor = 3'b000;
        moving_up = 1'b0;
        moving_down = 1'b0;
        emergency_stop = 1'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_floor <= current_floor;
            moving_up <= 1'b0;
            moving_down <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (floor_request > current_floor) begin
                        next_state <= MOVING_UP;
                        target_floor <= floor_request;
                        moving_up <= 1'b1;
                        moving_down <= 1'b0;
                    end else if (floor_request < current_floor) begin
                        next_state <= MOVING_DOWN;
                        target_floor <= floor_request;
                        moving_up <= 1'b0;
                        moving_down <= 1'b1;
                    end else begin
                        next_state <= IDLE; // Stay idle if the request is for the current floor
                    end
                end

                MOVING_UP: begin
                    if (current_floor < target_floor) begin
                        current_floor <= current_floor + 1; // Move up one floor
                    end else begin
                        next_state <= IDLE; // Reached target floor, go to idle
                        moving_up <= 1'b0;
                    end
                end

                MOVING_DOWN: begin
                    if (current_floor > target_floor) begin
                        current_floor <= current_floor - 1; // Move down one floor
                    end else begin
                        next_state <= IDLE; // Reached target floor, go to idle
                        moving_down <= 1'b0;
                    end
                end

                default: next_state <= IDLE; // Default to idle state for safety
            endcase
        end
    end


endmodule