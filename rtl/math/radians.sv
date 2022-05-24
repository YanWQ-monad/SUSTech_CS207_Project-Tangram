`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module radians (
    input  wire logic signed [`INT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    always_comb
        out = in * (`DEGREE_TO_RADIAN);

endmodule

`resetall
