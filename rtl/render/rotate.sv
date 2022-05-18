`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module rotate (
    input  wire logic signed [`FLOAT_BITS-1:0] x,
    input  wire logic signed [`FLOAT_BITS-1:0] y,
    input  wire logic signed [`INT_BITS-1:0] angle,
    output      logic signed [`FLOAT_BITS-1:0] x1,
    output      logic signed [`FLOAT_BITS-1:0] y1
);

    logic signed [`FLOAT_BITS-1:0] cos0, sin0;

    cos_deg cos(.in(angle), .out(cos0));
    sin_deg sin(.in(angle), .out(sin0));

    matrix_multiply m(
        .u1(x),
        .u2(y),
        .a11(cos0),
        .a12(sin0),
        .a21(-sin0),
        .a22(cos0),
        .v1(x1),
        .v2(y1)
    );

endmodule

`resetall
