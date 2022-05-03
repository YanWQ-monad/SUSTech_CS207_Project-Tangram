`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_clock_480p (
    input  wire logic clk_100m,       // input clock (100 MHz)
    input  wire logic rst,            // reset
    output      logic clk_pix,        // pixel clock
    output      logic clk_pix_locked  // pixel clock locked?
);

    // generate a 25MHz clock
    reg [3:0] cnt = 4'b1000;

    always_ff @(posedge clk_100m) begin
        if (rst) begin
            cnt <= 4'b1000;
            clk_pix <= 0;
            clk_pix_locked <= 0;
        end else begin
            clk_pix_locked <= 1;
            clk_pix <= cnt[0];
            cnt = { cnt[0], cnt[3:1] };
        end
    end

endmodule

`resetall
