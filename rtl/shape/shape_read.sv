module shape_read #(
    parameter DATAB = 3,   // data bits, 2^3 = 8
    parameter CORDW = 9,
    parameter ADDRW = 20,
    parameter DATAW = 12,
    parameter NUMW = DATAW
) (
    input  wire logic clk,
    input  wire logic rst,
    input  wire logic [NUMW-1:0] id,
    input  wire logic trigger,

    input  wire logic [ADDRW-1:0] ram_address_offset,
    output      logic [ADDRW-1:0] ram_address,         // read address
    output      logic             ram_enable,          // read enable
    input  wire logic [DATAW-1:0] ram_data,            // read data

    output      logic busy,
    output      logic [DATAW-1:0] ty,
    output      logic [CORDW-1:0] x,
    output      logic [CORDW-1:0] y,
    output      logic [DATAW-1:0] size,
    output      logic [DATAW-1:0] rotate
);

    initial ram_enable = 0;

    enum {IDLE, RAM_READ} state;
    logic [ADDRW-1:0] address;
    logic [DATAB-1:0] ptr;

    always_comb begin
        address = (id << DATAB) + ram_address_offset;
        ram_address = address + ptr;
        busy = state != IDLE;
    end

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                if (trigger) begin
                    state <= RAM_READ;
                    ptr <= 0;
                    ram_enable <= 1;
                end
            end
            RAM_READ: begin
                case (ptr)
                    0: ty <= ram_data;
                    1: x <= ram_data[CORDW-1:0];
                    2: y <= ram_data[CORDW-1:0];
                    3: size <= ram_data;
                    4: rotate <= ram_data;
                endcase

                if (ptr == ((1 << DATAB) - 1)) begin
                    state <= IDLE;
                    ram_enable <= 0;
                end else begin
                    ptr <= ptr + 1;
                end
            end
        endcase

        if (rst) begin
            state <= IDLE;
            ram_enable <= 0;
            ty <= 0;
            x <= 0;
            y <= 0;
            size <= 0;
        end
    end

endmodule
