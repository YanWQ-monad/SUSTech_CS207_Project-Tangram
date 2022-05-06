`resetall
`timescale 1ns / 1ps
`default_nettype none

module main_clock (
    output logic clk
);

    initial begin
        clk = 0;
        forever
            #5 clk = ~clk;
    end

endmodule

`resetall
