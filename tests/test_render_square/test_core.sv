module test_core #(parameter CORDW=9) (
    input  wire logic clk,
    input  wire logic rst,

    input  wire logic [CORDW-1:0] x0,    // point 0 x
    input  wire logic [CORDW-1:0] y0,    // point 0 y
    input  wire logic [CORDW-1:0] size,  // square edge length

    input  wire logic start,           // start line drawing
    output      logic [CORDW-1:0] y,   // drawing position y
    output      logic [CORDW-1:0] x,   // drawing position x
    output      logic drawing,         // actively drawing
    output      logic busy,            // drawing request in progress
    output      logic done             // drawing is complete (high for one tick)
);

    logic [CORDW-1:0] s, t;

    interval_square square(
        .x0,
        .y0,
        .size,
        .y,
        .s,
        .t
    );

    iter_line_scanner scanner(
        .clk,
        .rst,
        .start,
        .oe(1),

        .y,
        .x0(s),
        .x1(t),
        .x,
        .drawing,
        .busy,
        .done
    );

endmodule
