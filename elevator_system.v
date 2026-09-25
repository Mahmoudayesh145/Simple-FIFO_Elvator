module elevator_system (
    input clk,
    input rst,
    // Request interface
    input request_en,
    input [2:0] request_floor,
    // Status interface
    output [2:0] current_floor,
    output moving_up,
    output moving_down,
    output fifo_full,
    output fifo_empty
);

    wire [2:0] fifo_out;
    wire fifo_empty_int;
    reg read_en;
    
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
    reg [2:0] active_floor_request;

    // Elevator instantiation
    wire [2:0] next_floor;
    wire emergency_stop;
    
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
    localparam IDLE        = 2'b00;
    localparam PULL_REQ    = 2'b01;
    localparam WAIT_MOVING = 2'b10;
    localparam WAIT_STOP   = 2'b11;
    
    reg [1:0] ctrl_state, ctrl_next_state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctrl_state <= IDLE;
        end else begin
            ctrl_state <= ctrl_next_state;
        end
    end
    
    always @(*) begin
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
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active_floor_request <= 3'b000; // Initialize to floor 0
        end else if (ctrl_state == IDLE && !fifo_empty_int) begin
            // Capture the FIFO output in the exact same cycle we assert read_en
            active_floor_request <= fifo_out;
        end
    end

endmodule
