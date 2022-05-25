`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_timing_600p (
    input  wire logic clk_pix,   // pixel clock
    input  wire logic rst_pix,   // reset in pixel clock domain
    output      logic frame,     // new frame signal
    output      logic [9:0] sx,  // horizontal screen position
    output      logic [9:0] sy = 0,  // vertical screen position
    output      logic hsync,     // horizontal sync
    output      logic vsync,     // vertical sync
    output      logic de         // data enable (low in blanking interval)
);

    // horizontal timings
    parameter HA_END = 800;           // end of active pixels
    parameter HS_STA = HA_END + 40;   // sync starts after front porch
    parameter HS_END = HS_STA + 128;  // sync ends
    parameter LINE   = 1056-1;        // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 600;           // end of active pixels
    parameter VS_STA = VA_END + 1;    // sync starts after front porch
    parameter VS_END = VS_STA + 4;    // sync ends
    parameter SCREEN = 628-1;         // last line on screen (after back porch)

    logic [10:0] ix = 0;

    always_comb begin
        sx = ix[9:0];
        hsync = ~((ix >= HS_STA) && (ix < HS_END));
        vsync = ~((sy >= VS_STA) && (sy < VS_END));
        de = (ix < HA_END) && (sy < VA_END);
        frame = (ix == LINE) && (sy == SCREEN);
    end

    always_ff @(posedge clk_pix) begin
        if (rst_pix) begin
            ix <= 0;
            sy <= 0;
        end else if (ix == LINE) begin
            ix <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1;
        end else begin
            ix <= ix + 1;
        end
    end

endmodule

`resetall
