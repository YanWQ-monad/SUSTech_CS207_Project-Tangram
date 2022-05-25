`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module circular_step #(
    parameter DATAW = `INT_BITS,
    parameter DW_BOUND = -180,
    parameter UP_BOUND = 179
) (
    input  wire logic signed [DATAW-1:0] in,
    output      logic signed [DATAW-1:0] prev,
    output      logic signed [DATAW-1:0] next
);

    always_comb begin
        next = (in == UP_BOUND) ? DW_BOUND : (in + 1);
        prev = (in == DW_BOUND) ? UP_BOUND : (in - 1);
    end

endmodule

`resetall
