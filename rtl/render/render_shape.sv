`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module render_shape (
    input  wire logic        [`INT_BITS-1:0] ty,     // shape type
    input  wire logic signed [`INT_BITS-1:0] x0,     // reference point x
    input  wire logic signed [`INT_BITS-1:0] y0,     // reference point y
    input  wire logic        [`INT_BITS-1:0] size,   // shape size
    input  wire logic signed [`INT_BITS-1:0] angle,  // rotate angle (degree)

    input  wire logic signed [`INT_BITS-1:0] x,      // drawing position x
    input  wire logic signed [`INT_BITS-1:0] y,      // drawing position y

    output      logic out  // 1 if in the shape
);

    logic signed [`INT_BITS-1:0] dx, dy, ox, oy;
    logic signed [`FLOAT_BITS-1:0] fx, fy, rx, ry;

    rotate rotate(
        .x(fx),
        .y(fy),
        .angle,
        .x1(rx),
        .y1(ry)
    );

    always_comb begin
        dx = x - x0;
        dy = y - y0;

        fx = { dx, { `FLOAT_DCM_BITS{1'b0} } };
        fy = { dy, { `FLOAT_DCM_BITS{1'b0} } };

        ox = rx >>> `FLOAT_DCM_BITS;
        oy = ry >>> `FLOAT_DCM_BITS;

        // triangle
        out = (ox >= 0) && (oy >= 0) && (ox + oy < size);
    end

endmodule

`resetall
