`resetall
`timescale 1ns / 1ps
`default_nettype none

module render_by_type #(parameter CORDW=10, parameter DATAW=12) (
    input  wire logic clk,
    input  wire logic rst,

    input  wire logic [DATAW-1:0] ty,    // shape type
    input  wire logic [CORDW-1:0] x0,    // point 0 x
    input  wire logic [CORDW-1:0] y0,    // point 0 y
    input  wire logic [DATAW-1:0] size,  // square edge length

    input  wire logic start,           // start line drawing
    output      logic [CORDW-1:0] y,   // drawing position y
    output      logic [CORDW-1:0] x,   // drawing position x
    output      logic drawing,         // actively drawing
    output      logic busy,            // drawing request in progress
    output      logic done             // drawing is complete (high for one tick)
);

    logic [CORDW-1:0] s, t;

    logic [CORDW-1:0] s1, t1;
    interval_square square(
        .x0,
        .y0,
        .size(size[CORDW-1:0]),
        .y,
        .s(s1),
        .t(t1)
    );

    always_comb begin
        case (ty)
            0: begin
                s = s1;
                t = t1;
            end
            default: begin
                s = 1;
                t = 0;
            end
        endcase
    end

    iter_line_scanner scanner(
        .clk,
        .rst,
        .start,
        .oe(1'b1),

        .y,
        .x0(s),
        .x1(t),
        .x,
        .drawing,
        .busy,
        .done
    );

endmodule

`resetall
