`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "constants.h"

module sin (
    input  wire logic signed [`FLOAT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta3;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta5;

    logic signed [`FLOAT_DOUBLE_BITS-1:0] part2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] part3;

    logic signed [`FLOAT_DOUBLE_BITS-1:0] value;

    signed_extend #(
        .ORIGINAL_BITS(`FLOAT_BITS),
        .LEADING_BITS(`FLOAT_BITS),
        .FOLLOWING_BITS(0)
    ) extend(
        .in,
        .out(theta)
    );

    always_comb begin
        theta2 = (theta * theta) >>> (`FLOAT_DCM_BITS);
        theta3 = (theta2 * theta) >>> (`FLOAT_DCM_BITS);
        theta5 = (theta2 * theta3) >>> (`FLOAT_DCM_BITS);

        part2 = (theta3 * (`INV_6)) >>> (`FLOAT_DCM_BITS);
        part3 = (theta5 * (`INV_120)) >>> (`FLOAT_DCM_BITS);

        value = theta - part2 + part3;
        out = value[`FLOAT_BITS-1:0];
    end

endmodule

`resetall
