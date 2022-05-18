`resetall
`timescale 1ns / 1ps
`default_nettype none

module signed_extend #(
    parameter ORIGINAL_BITS = 32,
    parameter LEADING_BITS = 32,
    parameter FOLLOWING_BITS = 1
) (
    input  wire logic [LEADING_BITS-1:0] in,
    output      logic [ORIGINAL_BITS+LEADING_BITS+FOLLOWING_BITS-1:0] out
);

    logic sign;

    assign sign = in[LEADING_BITS-1];
    assign out = { { LEADING_BITS{sign} }, in, { FOLLOWING_BITS{1'b0} } };

endmodule

`resetall
