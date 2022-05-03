`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_timing_480p (
    input  wire logic clk_pix,   // pixel clock
    input  wire logic rst_pix,   // reset in pixel clock domain
    output      logic [9:0] sx,  // horizontal screen position
    output      logic [9:0] sy,  // vertical screen position
    output      logic hsync,     // horizontal sync
    output      logic vsync,     // vertical sync
    output      logic de         // data enable (low in blanking interval)
);

    // horizontal timings
    parameter HA_END = 639;           // end of active pixels
    parameter HS_STA = HA_END + 16;   // sync starts after front porch
    parameter HS_END = HS_STA + 96;   // sync ends
    parameter LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;           // end of active pixels
    parameter VS_STA = VA_END + 10;   // sync starts after front porch
    parameter VS_END = VS_STA + 2;    // sync ends
    parameter SCREEN = 524;           // last line on screen (after back porch)

    initial sx = 0;
    initial sy = 0;

    always_comb begin
        hsync = ~((sx > HS_STA) && (sx <= HS_END));
        vsync = ~((sy > VS_STA) && (sy <= VS_END));
        de = (sx <= HA_END) && (sy <= VA_END);
    end

    always_ff @(posedge clk_pix) begin
        if (sx == LINE) begin
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1;
        end else begin
            sx <= sx + 1;
        end

        if (rst_pix) begin
            sx <= 0;
            sy <= 0;
        end
    end

endmodule

`resetall
