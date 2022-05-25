`resetall
`timescale 1ns / 1ps
`default_nettype none

module input_mode (
    input  wire logic clk,
    input  wire logic rst,

    input  wire logic in,
    input  wire logic down,

    input  wire logic mode,  // 0 for direct, 1 for once
    input  wire logic clr,   // reset "once"

    output      logic out,
    output      logic once = 0,
    output      logic [1:0] mag
);

    logic [7:0] cnt = 0;

    assign mag = mode ? 2'b00 : cnt[7:6];
    always_comb
        out = mode ? once : in;

    always_ff @(posedge clk) begin
        if (rst) begin
            once <= 0;
            cnt <= 0;
        end else if (clr) begin
            once <= 0;
            if (in && ~(&cnt))
                cnt <= cnt + 1;
        end else begin
            if (down)
                once <= 1;
            if (~in)
                cnt <= 0;
        end
    end

endmodule

`resetall
