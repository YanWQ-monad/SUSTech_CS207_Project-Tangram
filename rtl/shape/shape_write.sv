`resetall
`timescale 1ns / 1ps
`default_nettype none

module shape_write #(
    parameter DATAB = 3,   // data bits, 2^3 = 8
    parameter CORDW = 10,
    parameter ADDRW = 20,
    parameter DATAW = 12,
    parameter NUMW = DATAW
) (
    input  wire logic clk,
    input  wire logic rst,
    input  wire logic [NUMW-1:0] id,
    input  wire logic trigger,

    input  wire logic [ADDRW-1:0] ram_address_offset,
    output      logic [ADDRW-1:0] ram_address,         // write address
    output      logic             ram_enable,          // write enable
    output      logic [DATAW-1:0] ram_data,            // write data

    output      logic busy,
    input  wire logic [DATAW-1:0] ty,
    input  wire logic [CORDW-1:0] x,
    input  wire logic [CORDW-1:0] y,
    input  wire logic [DATAW-1:0] size,
    input  wire logic [DATAW-1:0] rotate
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

    always_comb begin
        case (ptr)
            0: ram_data = ty;
            1: ram_data = { 3'b000, x };
            2: ram_data = { 3'b000, y };
            3: ram_data = size;
            4: ram_data = rotate;
            default: ram_data = 0;
        endcase
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
                if (ptr == ((1 << DATAB) - 1)) begin
                    ram_enable <= 0;
                    state <= IDLE;
                end else begin
                    ptr <= ptr + 1;
                end
            end
        endcase

        if (rst) begin
            state <= IDLE;
            ram_enable <= 0;
        end
    end

endmodule

`resetall
