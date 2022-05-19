`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_clock_600p (
    input  wire logic clk_100m,  // 100 MHz clock
    input  wire logic rst,
    output      logic clk_pix,
    output      logic clk_pix_locked
);

    // Vivado IP: Clocking Wizard
    clk_wiz_0 wiz(
        .reset(rst),
        .clk_in1(clk_100m),
        .clk_out1(clk_pix),
        .locked(clk_pix_locked)
    );

endmodule

`resetall
