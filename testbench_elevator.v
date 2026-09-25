module testbench_elevator;

    // Inputs
    reg clk;
    reg rst;
    reg request_en;
    reg [2:0] request_floor;

    // Outputs
    wire [2:0] current_floor;
    wire moving_up;
    wire moving_down;
    wire fifo_full;
    wire fifo_empty;

    // Instantiate the Unit Under Test (UUT)
    main uut (
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

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        request_en = 0;
        request_floor = 0;

        // Reset the system
        #20;
        rst = 0;
        #10;

        // Push first request: Floor 3
        request_floor = 3;
        request_en = 1;
        #10;
        request_en = 0;
        
        #10;
        
        // Push second request: Floor 5
        request_floor = 5;
        request_en = 1;
        #10;
        request_en = 0;

        // Push third request: Floor 1
        request_floor = 1;
        request_en = 1;
        #10;
        request_en = 0;

        // Wait to observe elevator movement
        // Moving from 0 -> 3 (takes some cycles)
        // Then 3 -> 5
        // Then 5 -> 1
        #500;
        
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | Floor=%0d | Up=%b Down=%b | ReqEmpty=%b ReqFull=%b", 
                 $time, current_floor, moving_up, moving_down, fifo_empty, fifo_full);
    end

endmodule
