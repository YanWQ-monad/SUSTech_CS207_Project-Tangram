`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module render_shape_basic (
    input  wire logic signed [`INT_BITS-1:0] x,
    input  wire logic signed [`INT_BITS-1:0] y,
    input  wire logic        [`INT_BITS-1:0] ty,
    input  wire logic        [`INT_BITS-1:0] size,

    output      logic out  // 1 if in the shape
);

    logic signed [`INT_BITS-1:0] sum, sub, hy;

    always_comb begin
        sum = x + y;
        sub = x - y;
        hy = y >>> 1;

        case (ty)
            0: out = (x >= 0) && (y >= 0) && (sum < size);  // triangle
            1: out = (y >= 0) && (hy <= x) && (x + hy < size);  // equilateral triangle
            2: out = (x >= 0) && (y >= 0) && (x < size) && (y < size);  // square
            3: out = (x >= 0) && (y >= 0) && (x < size) && (hy < size);  // rectangle
            4: out = (y >= 0) && (y < size) && (sum >= 0) && (sum < size);  // parallelogram
            5: out = (y >= 0) && (y < size) && (sub >= 0) && (sub < (size << 1));  // parallelogram 2
            default: out = 0;
        endcase
    end

endmodule

`resetall
