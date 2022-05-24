`resetall
`timescale 1ns / 1ps
`default_nettype none

module tube_4_display (
    input  wire logic clk,

    input  wire logic [3:0] in1,
    input  wire logic [3:0] in2,
    input  wire logic [3:0] in3,
    input  wire logic [3:0] in4,

    input  wire logic [3:0] dp,

    output      logic [3:0] en,
    output      logic [7:0] out   // PGFEDCBA
);

    parameter CNT_W = 16;
    logic [CNT_W-1:0] cnt;
    logic [3:0] d;
    logic [1:0] id;

    bcd_to_tube to(.in(d), .out(out[6:0]));

    always_ff @(posedge clk) begin
        if (&cnt) begin
            id <= id + 1;
        end
        cnt <= cnt + 1;
    end

    assign out[7] = dp[id];

    always_comb begin
        case (id)
            2'd0: d = in1;
            2'd1: d = in2;
            2'd2: d = in3;
            2'd3: d = in4;
        endcase

        case (id)
            2'd0: en = 4'b0001;
            2'd1: en = 4'b0010;
            2'd2: en = 4'b0100;
            2'd3: en = 4'b1000;
        endcase
    end

endmodule

`resetall
