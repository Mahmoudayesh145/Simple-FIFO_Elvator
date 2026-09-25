module main (
    input clk,
    input rst,
    input request_en,
    input [2:0] request_floor,
    output [2:0] current_floor,
    output moving_up,
    output moving_down,
    output fifo_full,
    output fifo_empty
);

    elevator_system sys (
        .clk(clk),
        .rst(rst),
        .request_en(request_en),
        .request_floor(request_floor),
        .current_floor(current_floor),
        .moving_up(moving_up),
        .moving_down(moving_down),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

endmodule