`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module render_shape (
    input  wire logic clk,
    input  wire logic newline,
    input  wire logic newframe,

    input  wire logic        [`INT_BITS-1:0] ty,
    input  wire logic        [`INT_BITS-1:0] size,
    input  wire logic signed [`FLOAT_BITS-1:0] sin,
    input  wire logic signed [`FLOAT_BITS-1:0] cos,
    input  wire logic signed [`FLOAT_BITS-1:0] ix,
    input  wire logic signed [`FLOAT_BITS-1:0] iy,

    output      logic out  // 1 if in the shape
);

    logic signed [`INT_BITS-1:0] ox, oy, sum, hy;
    logic signed [`FLOAT_BITS-1:0] x, y, rx, ry;

    always_ff @(posedge clk) begin
        if (newframe) begin
            x <= ix;
            y <= iy;
            rx <= ix - sin;
            ry <= iy + cos;
        end else if (newline) begin
            x <= rx;
            y <= ry;
            rx <= rx - sin;
            ry <= ry + cos;
        end else begin
            x <= x + cos;
            y <= y + sin;
        end
    end

    always_comb begin
        ox = x >>> `FLOAT_DCM_BITS;
        oy = y >>> `FLOAT_DCM_BITS;
        sum = ox + oy;
        hy = oy >>> 1;

        case (ty)
            0: out = (ox >= 0) && (oy >= 0) && (sum < size);  // triangle
            1: out = (oy >= 0) && (hy <= ox) && (ox + hy < size);  // equilateral triangle
            2: out = (ox >= 0) && (oy >= 0) && (ox < size) && (oy < size);  // square
            3: out = (ox >= 0) && (oy >= 0) && (ox < size) && (hy < size);  // rectangle
            4: out = (oy >= 0) && (oy < size) && (sum >= 0) && (sum < size);  // parallelogram
            default: out = 0;
        endcase
    end

endmodule

`resetall
