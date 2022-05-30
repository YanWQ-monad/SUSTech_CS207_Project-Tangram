`resetall
`timescale 1ns / 1ps
`default_nettype none

module clk_wiz_0 (
    input  wire logic reset,
    input  wire logic clk_in1,
    output      logic clk_out1,
    output      logic locked
);

    assign locked = 1;
    assign clk_out1 = clk_in1;

endmodule

`resetall
