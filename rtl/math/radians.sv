`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "constants.h"

module radians (
    input  wire logic signed [`INT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`FLOAT_BITS-1:0] in2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta;

    always_comb begin
        in2 = { in, { `FLOAT_DCM_BITS{1'b0} } };
        theta = (in2 * (`PI) * (`INV_180)) >>> (`FLOAT_DCM_BITS * 2);
        out = theta[`FLOAT_BITS-1:0];
    end

endmodule

`resetall
