// this code will represents simple elvator consist of 8 floors from 0 to 7
module Elevator(
    input rst,
    input clk,
    input [2:0] floor_request,
    output reg [2:0] current_floor,
    output reg moving_up,
    output reg moving_down,
    output reg [2:0] next_floor,
    output reg emergency_stop
);
    
    // Internal state variables
    reg [2:0] requested_floors; // 3-bit register to store requested floors
    reg [2:0] target_floor; // 3-bit register to store the target floor


    typedef enum logic [1:0] {
        IDLE = 2'b00,
        MOVING_UP = 2'b01,
        MOVING_DOWN = 2'b10,
    } state_t;

    state_t current_state;
    state_t next_state;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            moving_up <= 1'b0;
            moving_down <= 1'b0;
            target_floor <= current_floor;
            moving_up <= 1'b0;
            moving_down <= 1'b0;
        end else begin
            // Handle movement logic here
        end
    end


endmodule