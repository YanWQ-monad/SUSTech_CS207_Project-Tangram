`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "constants.h"

/*
                  +-----+-----+
   +------------- | a11 | a12 |
   |              +-----+-----+
   |     +------- | a21 | a22 |
   |     |        +-----+-----+
   |     |           |     |
+-----+-----+     +-----+-----+
| u1  | u2  |     | v1  | v2  |
+-----+-----+     +-----+-----+
*/

module matrix_multiply (
    input  wire logic signed [`FLOAT_BITS-1:0] u1,
    input  wire logic signed [`FLOAT_BITS-1:0] u2,
    input  wire logic signed [`FLOAT_BITS-1:0] a11,
    input  wire logic signed [`FLOAT_BITS-1:0] a12,
    input  wire logic signed [`FLOAT_BITS-1:0] a21,
    input  wire logic signed [`FLOAT_BITS-1:0] a22,
    output      logic signed [`FLOAT_BITS-1:0] v1,
    output      logic signed [`FLOAT_BITS-1:0] v2
);

    logic signed [`FLOAT_DOUBLE_BITS-1:0] b1, b2, b3, b4;

    always_comb begin
        b1 = (u1 * a11) >>> (`FLOAT_DCM_BITS);
        b2 = (u2 * a21) >>> (`FLOAT_DCM_BITS);
        v1 = b1 + b2;

        b3 = (u1 * a12) >>> (`FLOAT_DCM_BITS);
        b4 = (u2 * a22) >>> (`FLOAT_DCM_BITS);
        v2 = b3 + b4;
    end

endmodule

`resetall
