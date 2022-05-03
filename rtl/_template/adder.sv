`resetall
`timescale 1ns / 1ps
`default_nettype none

module adder #(
    parameter integer DATA_WIDTH = 4
) (
    output logic unsigned [DATA_WIDTH:0]   out,
    input  logic unsigned [DATA_WIDTH-1:0] a,
    input  logic unsigned [DATA_WIDTH-1:0] b
);

assign out = a + b;

endmodule

`resetall
