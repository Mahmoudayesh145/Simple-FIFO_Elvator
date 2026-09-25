module FIFO #(
    parameter DEPTH = 8,
    parameter WIDTH = 3
)(
    input  logic             clk,
    input  logic             reset,

    // Write side
    input  logic             write_en,
    input  logic [WIDTH-1:0] floor_in,

    // Read side
    input  logic             read_en,
    output logic [WIDTH-1:0] floor_out,

    // Status
    output logic             full,
    output logic             empty
);

    // Memory: 8 entries, each entry is 3 bits
    logic [WIDTH-1:0] memory [0:DEPTH-1];

    // Pointers
    logic [2:0] write_ptr;
    logic [2:0] read_ptr;

    // Number of items currently inside FIFO
    logic [3:0] count;


    // FIFO operation
    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            floor_out <= 0;

        end

        else begin

            // WRITE
            if (write_en && !full) begin

                memory[write_ptr] <= floor_in;

                write_ptr <= write_ptr + 1;

            end


            // READ
            if (read_en && !empty) begin

                floor_out <= memory[read_ptr];

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