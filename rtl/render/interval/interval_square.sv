`resetall
`timescale 1ns / 1ps
`default_nettype none

module interval_square #(parameter CORDW=10) (
    input  wire logic [CORDW-1:0] x0,    // point 0 x
    input  wire logic [CORDW-1:0] y0,    // point 0 y
    input  wire logic [CORDW-1:0] size,  // square edge length

    input  wire logic [CORDW-1:0] y,   // drawing position y (which line)
    output      logic [CORDW-1:0] s,  // line interval dependent on y
    output      logic [CORDW-1:0] t
);

    logic [CORDW-1:0] x1, y1;

    always_comb begin
        x1 = x0 + size;
        y1 = y0 + size;

        if (y < y0 || y > y1) begin
            // s > t, means an empty interval
            s = 1;
            t = 0;
        end else begin
            s = x0;
            t = x1;
        end
    end

endmodule

`resetall
