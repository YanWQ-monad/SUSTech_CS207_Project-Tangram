`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "constants.h"

module radians (
    input  wire logic signed [`INT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`FLOAT_DOUBLE_BITS-1:0] in2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta;

    signed_extend #(
        .ORIGINAL_BITS(`INT_BITS),
        .LEADING_BITS(`FLOAT_BITS),
        .FOLLOWING_BITS(`FLOAT_DCM_BITS)
    ) extend(
        .in,
        .out(in2)
    );

    always_comb begin
        theta = (in2 * (`PI) * (`INV_180)) >>> (`FLOAT_DCM_BITS * 2);
        out = theta[`FLOAT_BITS-1:0];
    end
    
endmodule

`resetall
