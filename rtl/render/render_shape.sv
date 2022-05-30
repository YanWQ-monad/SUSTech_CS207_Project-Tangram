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

    logic signed [`INT_BITS-1:0] sum, sub, hy;
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

    render_shape_basic basic(
        .x(x[`FLOAT_BITS-1:`FLOAT_DCM_BITS]),
        .y(y[`FLOAT_BITS-1:`FLOAT_DCM_BITS]),
        .ty,
        .size,
        .out
    );

endmodule

`resetall
