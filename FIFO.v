module FIFO #(
    parameter DEPTH = 8,
    parameter WIDTH = 3
)(
    input  clk,
    input  reset,

    // Write side
    input  write_en,
    input  [WIDTH-1:0] floor_in,

    // Read side
    input  read_en,
    output [WIDTH-1:0] floor_out,

    // Status
    output full,
    output empty
);

    // Memory: 8 entries, each entry is 3 bits
    reg [WIDTH-1:0] memory [0:DEPTH-1];

    // Pointers
    reg [2:0] write_ptr;
    reg [2:0] read_ptr;

    // Number of items currently inside FIFO
    reg [3:0] count;
    integer i;


    // The next queued floor is visible without waiting for a clock edge.
    assign floor_out = memory[read_ptr];

    // FIFO operation
    always @(posedge clk or posedge reset) begin

        if (reset) begin

            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                memory[i] <= 0;
            end
        end

        else begin

            // WRITE
            if (write_en && !full) begin

                memory[write_ptr] <= floor_in;

                write_ptr <= write_ptr + 1;

            end


            // READ
            if (read_en && !empty) begin

                read_ptr <= read_ptr + 1;

            end


            // Update count
            case ({write_en && !full, read_en && !empty})

                2'b10:
                    count <= count + 1;   // write only

                2'b01:
                    count <= count - 1;   // read only

                default:
                    count <= count;       // no change or both read and write

            endcase

        end
    end
    
    // FIFO status
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

endmodule