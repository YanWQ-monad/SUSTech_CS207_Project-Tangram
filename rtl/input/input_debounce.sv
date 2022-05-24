`resetall
`timescale 1ns / 1ps
`default_nettype none

module input_debounce (
    input  wire logic clk,   // clock
    input  wire logic in,    // signal input
    output      logic out = 0,   // signal output (debounced)
    output      logic ondn,  // on down (one tick)
    output      logic onup   // on up (one tick)
);

    // sync with clock and combat metastability
    logic sync_0, sync_1;
    always_ff @(posedge clk) sync_0 <= in;
    always_ff @(posedge clk) sync_1 <= sync_0;

    logic [17:0] cnt = 0;  // 2^18 = 6.55 ms counter at 40 MHz
    logic idle, max;
    always_comb begin
        idle = (out == sync_1);
        max  = &cnt;
        ondn = (~idle) & max & (~out);
        onup = (~idle) & max & out;
    end

    always_ff @(posedge clk) begin
        if (idle) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            if (max)
                out <= ~out;
        end
    end
endmodule

`resetall
