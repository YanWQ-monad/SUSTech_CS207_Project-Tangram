`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "./constants.h"

module cos (
    input  wire logic signed [`FLOAT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`FLOAT_BITS-1:0] theta;

    sin sin(.in(theta), .out);

    always_comb begin
        if (in > `HALF_PI)
            theta = in - `THIRD_TWO_PI;
        else
            theta = in + `HALF_PI;
    end
    
endmodule

`resetall
