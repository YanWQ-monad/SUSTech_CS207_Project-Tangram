`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_pixel_id (
    output      logic [19:0] id,
    input  wire logic [9:0] x,
    input  wire logic [9:0] y
);

    parameter H_PIXEL = 640;  // horizontal pixels
    parameter V_PIXEL = 480;  // vertical pixels

    always_comb begin
        id = y * H_PIXEL + x;
    end

endmodule

`resetall
