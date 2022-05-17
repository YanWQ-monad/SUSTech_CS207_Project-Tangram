`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "./constants.h"

module sin (
    input  wire logic signed [`FLOAT_BITS-1:0] in,
    output      logic signed [`FLOAT_BITS-1:0] out
);

    logic signed [`FLOAT_BITS-1:0] theta_o;

    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta3;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta4;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] theta5;

    logic signed [`FLOAT_DOUBLE_BITS-1:0] part2;
    logic signed [`FLOAT_DOUBLE_BITS-1:0] part3;

    logic signed [`FLOAT_DOUBLE_BITS-1:0] value;

    always_comb begin
        if (in > (`HALF_PI))
            theta_o = (`PI) - in;
        else if (in < -(`HALF_PI))
            theta_o = - (`PI) - in;
        else
            theta_o = in;

        // signed extend
        theta = { { `FLOAT_BITS{theta_o[`FLOAT_BITS-1]} }, theta_o[`FLOAT_BITS-1:0] };

        theta2 = (theta * theta) >>> (`FLOAT_DCM_BITS);
        theta3 = (theta2 * theta) >>> (`FLOAT_DCM_BITS);
        theta4 = (theta2 * theta2) >>> (`FLOAT_DCM_BITS);
        theta5 = (theta4 * theta) >>> (`FLOAT_DCM_BITS);

        part2 = (theta3 * (`INV_6)) >>> (`FLOAT_DCM_BITS);
        part3 = (theta5 * (`INV_20)) >>> (`FLOAT_DCM_BITS);

        value = theta - part2 + part3;
        out = value[`FLOAT_BITS-1:0];
    end

endmodule

`resetall
