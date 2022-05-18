`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "constants.h"

module sin_deg (
    input  wire logic signed [`INT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`INT_BITS-1:0] in2;
    logic signed [`FLOAT_BITS-1:0] theta;

    radians radians(.in(in2), .out(theta));
    sin sin(.in(theta), .out);

    always_comb
        if (in > 16'sd90)
            in2 = 16'sd180 - in;
        else if (in < -16'sd90)
            in2 = - (16'sd180) - in;
        else
            in2 = in;

endmodule

`resetall