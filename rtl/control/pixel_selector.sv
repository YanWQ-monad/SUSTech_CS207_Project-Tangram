`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module pixel_selector #(
    parameter MAXSHP = 16
) (
    input  wire logic [MAXSHP-1:0] en,
    output      logic black,
    output      logic [`INT_BITS-1:0] id,
    output      logic multiple
);

    assign multiple = |(en & (en - 1));

    always_comb begin
        black = ~(|en);
        casex (en)
            `include "rtl/control/pixel_selector.sv.partial"
        endcase
    end

endmodule

`resetall
