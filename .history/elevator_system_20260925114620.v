module elevator_system (
    input logic clk,
    input logic rst,
    // Request interface
    input logic request_en,
    input logic [2:0] request_floor,
    // Status interface
    output logic [2:0] current_floor,
    output logic moving_up,
    output logic moving_down,
    output logic fifo_full,
    output logic fifo_empty
);

    logic [2:0] fifo_out;
    logic fifo_empty_int;
    logic read_en;
    
    // Instantiate the FIFO
    FIFO #(
        .DEPTH(8),
        .WIDTH(3)
    ) req_fifo (
        .clk(clk),
        .reset(rst),
        .write_en(request_en),
        .floor_in(request_floor),
        .read_en(read_en),
        .floor_out(fifo_out),
        .full(fifo_full),
        .empty(fifo_empty_int)
    );
    
    assign fifo_empty = fifo_empty_int;

    // We need a register to hold the current active request for the elevator
    logic [2:0] active_floor_request;

    // Elevator instantiation
    logic [2:0] next_floor;
    logic emergency_stop;
    
    Elevator elevator_inst (
        .clk(clk),
        .rst(rst),
        .floor_request(active_floor_request),
        .current_floor(current_floor),
        .next_floor(next_floor),
        .moving_up(moving_up),
        .moving_down(moving_down),
        .emergency_stop(emergency_stop)
    );

    // Controller logic to read from FIFO and feed the elevator
    typedef enum logic [1:0] {
        IDLE,
        PULL_REQ,
        WAIT_MOVING,
        WAIT_STOP
    } ctrl_state_t;
    
    ctrl_state_t ctrl_state, ctrl_next_state;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ctrl_state <= IDLE;
        end else begin
            ctrl_state <= ctrl_next_state;
        end
    end
    
    always_comb begin
        ctrl_next_state = ctrl_state;
        read_en = 1'b0;
        
        case (ctrl_state)
            IDLE: begin
                if (!fifo_empty_int) begin
                    read_en = 1'b1; // Pop the next request from FIFO
                    ctrl_next_state = PULL_REQ;
                end
            end
            PULL_REQ: begin
                // The new request is now registered into active_floor_request
                if (active_floor_request == current_floor) begin
                    // If already at requested floor, elevator won't move
                    ctrl_next_state = IDLE; 
                end else begin
                    ctrl_next_state = WAIT_MOVING;
                end
            end
            WAIT_MOVING: begin
                // Wait for the elevator to acknowledge the request and start moving
                if (moving_up || moving_down) begin
                    ctrl_next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                // Wait for the elevator to stop (reach the target floor)
                if (!moving_up && !moving_down) begin
                    ctrl_next_state = IDLE;
                end
            end
            default: ctrl_next_state = IDLE;
        endcase
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            active_floor_request <= 3'b000; // Initialize to floor 0
        end else if (ctrl_state == IDLE && !fifo_empty_int) begin
            // Capture the FIFO output in the exact same cycle we assert read_en
            active_floor_request <= fifo_out;
        end
    end

endmodule
