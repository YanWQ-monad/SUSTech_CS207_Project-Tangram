`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module color_map #(
    parameter PIXLW = 12,
    parameter COLRW = 4
) (
    input  wire logic [`INT_BITS-1:0] x,
    input  wire logic [`INT_BITS-1:0] y,
    input  wire logic [`INT_BITS-1:0] sx,
    input  wire logic [`INT_BITS-1:0] sy,
    output      logic [PIXLW-1:0] color,
    output      logic [PIXLW-1:0] render
);

    logic signed [`INT_BITS-1:0] dx, dy;
    logic [PIXLW-1:0] t_render;

    assign t_render = { sy[6:1], sx[6:1] };
    assign color = { y[6:1], x[6:1] };

    always_comb begin
        dx = sx - x;
        dy = sy - y;

        if (x == sx && y == sy)
            render = t_render;
        else if (x == sx && (-3 <= dy && dy <= 3))
            render = 12'hFFF;
        else if (y == sy && (-3 <= dx && dx <= 3))
            render = 12'hFFF;
        else
            render = t_render;
    end

endmodule

`resetall
