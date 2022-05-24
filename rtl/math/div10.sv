`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module div10 (
    input  wire logic [`INT_BITS-1:0] in,
    output      logic [`INT_BITS-1:0] quotient,
    output      logic [3:0] remainder
);

    logic [`INT_BITS-1:0] q, r;

    always_comb begin
        q = (in >> 1) + (in >> 2);
        q = q + (q >> 4);
        q = q + (q >> 8);
        q = q + (q >> 16);
        q = q >> 3;
        r = in - (((q << 2) + q) << 1);
        quotient = q + (r > 9);
        remainder = in - (quotient << 1) - (quotient << 3);
    end

endmodule

`resetall
