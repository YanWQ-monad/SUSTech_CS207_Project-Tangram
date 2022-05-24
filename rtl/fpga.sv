`resetall
`timescale 1ns / 1ps
`default_nettype none

module fpga (
    input  wire logic clk,
    input  wire logic reset,

    input  wire logic l_btn_r,  // left button
    input  wire logic r_btn_r,  // right button
    input  wire logic u_btn_r,  // up button
    input  wire logic d_btn_r,  // down button
    input  wire logic c_btn_r,  // center button

    input  wire logic swch_1_r,  // mode 1: select shape(C) & resize(UD) & remove/add(LR)
    input  wire logic swch_2_r,  // mode 2: color choose
    input  wire logic swch_3_r,

    output      logic out_1,   // collision detection
    output      logic [7:0] tube_l,
    output      logic [7:0] tube_r,
    output      logic [7:0] tube_en,

    output      logic vga_hsync,          // VGA horizontal sync
    output      logic vga_vsync,          // VGA vertical sync
    output      logic [3:0] vga_r,  // 4-bit VGA red
    output      logic [3:0] vga_g,  // 4-bit VGA green
    output      logic [3:0] vga_b   // 4-bit VGA blue
);

    logic rst;

    logic clk_pix, clk_pix_locked;
    logic l_btn, r_btn, u_btn, d_btn, c_btn, swch_1, swch_2, swch_3;
    logic l_btn_dn, r_btn_dn, u_btn_dn, d_btn_dn, c_btn_dn;

    vga_clock_600p clock(
        .clk_100m(clk),
        .rst(~reset),
        .clk_pix,
        .clk_pix_locked
    );

    input_debounce l_btn_deb(.clk(clk_pix), .in(l_btn_r), .out(l_btn), .ondn(l_btn_dn), .onup());
    input_debounce r_btn_deb(.clk(clk_pix), .in(r_btn_r), .out(r_btn), .ondn(r_btn_dn), .onup());
    input_debounce u_btn_deb(.clk(clk_pix), .in(u_btn_r), .out(u_btn), .ondn(u_btn_dn), .onup());
    input_debounce d_btn_deb(.clk(clk_pix), .in(d_btn_r), .out(d_btn), .ondn(d_btn_dn), .onup());
    input_debounce c_btn_deb(.clk(clk_pix), .in(c_btn_r), .out(c_btn), .ondn(c_btn_dn), .onup());
    input_debounce swch_1_deb(.clk(clk_pix), .in(swch_1_r), .out(swch_1), .ondn(), .onup());
    input_debounce swch_2_deb(.clk(clk_pix), .in(swch_2_r), .out(swch_2), .ondn(), .onup());
    input_debounce swch_3_deb(.clk(clk_pix), .in(swch_3_r), .out(swch_3), .ondn(), .onup());

    core core(
        .clk(clk_pix),
        .rst,

        .l_btn,
        .r_btn,
        .u_btn,
        .d_btn,
        .c_btn,

        .l_btn_dn,
        .r_btn_dn,
        .u_btn_dn,
        .d_btn_dn,
        .c_btn_dn,

        .swch_1,
        .swch_2,
        .swch_3,

        .out_1,
        .tube_l,
        .tube_r,
        .tube_en,

        .vga_hsync,
        .vga_vsync,
        .vga_r,
        .vga_g,
        .vga_b
    );

    always_comb begin
        rst = (~clk_pix_locked) | (~reset);
    end

endmodule

`resetall
