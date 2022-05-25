`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module rotate (
    input  wire logic signed [`FLOAT_BITS-1:0] x,
    input  wire logic signed [`FLOAT_BITS-1:0] y,
    input  wire logic signed [`FLOAT_BITS-1:0] sin,
    input  wire logic signed [`FLOAT_BITS-1:0] cos,
    output      logic signed [`FLOAT_BITS-1:0] x1,
    output      logic signed [`FLOAT_BITS-1:0] y1
);

    matrix_multiply m(
        .u1(x),
        .u2(y),
        .a11(cos),
        .a12(sin),
        .a21(-sin),
        .a22(cos),
        .v1(x1),
        .v2(y1)
    );

endmodule

`resetall
