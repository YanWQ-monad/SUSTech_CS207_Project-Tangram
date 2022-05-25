`resetall
`timescale 1ns / 1ps
`default_nettype none

`include "rtl/math/constants.h"

module core #(
    parameter CORDW = 10,
    parameter PIXLW = 12,
    parameter COLRW = 4,
    parameter MAXSHP = 4
) (
    input  wire logic clk,   // ens clock
    input  wire logic rst,

    // 5-Direction Buttons
    input  wire logic l_btn,  // left button
    input  wire logic r_btn,  // right button
    input  wire logic u_btn,  // up button
    input  wire logic d_btn,  // down button
    input  wire logic c_btn,  // center button

    input  wire logic l_btn_dn,
    input  wire logic r_btn_dn,
    input  wire logic u_btn_dn,
    input  wire logic d_btn_dn,
    input  wire logic c_btn_dn,

    // Switches                // mode 0: move position
    input  wire logic swch_1,  // mode 1: resize(UD) & rotate(LR) & change shape(C)
    input  wire logic swch_2,  // mode 2: remove/add(LR) & switch shape(C)
    input  wire logic swch_3,  // mode 3: color choose
    input  wire logic swch_6,  // switch tube mode (0 for [x, y, id], 1 for [size, angle])
    input  wire logic swch_7,  // switch button mode

    // Output (LED)
    output      logic out_1,   // collision detection
    output      logic [7:0] tube_l,
    output      logic [7:0] tube_r,
    output      logic [7:0] tube_en,

    // VGA
    output      logic vga_hsync,          // VGA horizontal sync
    output      logic vga_vsync,          // VGA vertical sync
    output      logic [COLRW-1:0] vga_r,  // 4-bit VGA red
    output      logic [COLRW-1:0] vga_g,  // 4-bit VGA green
    output      logic [COLRW-1:0] vga_b   // 4-bit VGA blue
);

    parameter MAX_TYPE = 4 - 1;
    parameter COLOR_X = 340;
    parameter COLOR_Y = 240;
    parameter COLOR_SIZE = 64 * 2;

    logic l_btn_p, r_btn_p, u_btn_p, d_btn_p, c_btn_p;

    // VGA properties
    logic [CORDW-1:0] sx, sy;
    logic frame, de;

    // Shapes properties
    logic [`INT_BITS-1:0] s_ty [MAXSHP-1:0];
    logic [`INT_BITS-1:0] s_x [MAXSHP-1:0];
    logic [`INT_BITS-1:0] s_y [MAXSHP-1:0];
    logic [`INT_BITS-1:0] s_size [MAXSHP-1:0];
    logic signed [`INT_BITS-1:0] s_angle [MAXSHP-1:0];
    logic [PIXLW-1:0] s_color [MAXSHP-1:0];
    logic [MAXSHP-1:0] ens;

    // Angle rotation
    logic [`INT_BITS-1:0] p_angle, n_angle;

    logic [`INT_BITS-1:0] number;
    logic [`INT_BITS-1:0] s_id;
    logic [PIXLW-1:0] r_color;
    logic collision, black;

    // Color picker
    logic [`INT_BITS-1:0] cx, cy;
    logic [`INT_BITS-1:0] csx, csy;
    logic color_en;
    logic [PIXLW-1:0] c_color, c_render;

    // Tube
    logic [`INT_BITS-1:0] t_angle;
    logic [3:0] t_digit1 [7:0];
    logic [3:0] t_digit2 [7:0];
    logic [7:0] tube_1l, tube_1r, tube_2l, tube_2r;
    logic [7:0] dip_1, dip_2;
    logic [7:0] ten_1, ten_2;
    logic [`INT_BITS-1:0] temps[8:0];

    logic [`INT_BITS-1:0] x, y;
    logic [PIXLW-1:0] o_color;

    initial s_size[0] = 10;  // todo: move to init

    assign x = sx;
    assign y = sy;
    assign csx = sx - COLOR_X;
    assign csy = sy - COLOR_Y;
    assign out_1 = collision;
    assign dip_1 = 8'b00100100;
    assign dip_2 = 8'b00000000;

    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            initial t_digit1[j] = 4'hA;
            initial t_digit2[j] = 4'hA;
        end
    endgenerate

    genvar i;
    generate
        for (i = 0; i < MAXSHP; i = i + 1)
            render_shape render(
                .ty(s_ty[i]),
                .x0(s_x[i]),
                .y0(s_y[i]),
                .size(s_size[i]),
                .angle(s_angle[i]),
                .x,
                .y,
                .out(ens[i])
            );
    endgenerate

    circular_step #(.DATAW(`INT_BITS), .DW_BOUND(-180), .UP_BOUND(179)) step(
        .in(s_angle[0]),
        .prev(p_angle),
        .next(n_angle)
    );

    pixel_selector #(.PIXLW(PIXLW), .MAXSHP(MAXSHP)) select(
        .en(ens),
        .black,
        .id(s_id),
        .multiple(collision)
    );

    color_map #(.PIXLW(PIXLW), .COLRW(COLRW)) map(
        .x(cx),
        .y(cy),
        .sx(csx),
        .sy(csy),
        .color(c_color),
        .render(c_render)
    );

    vga_timing_600p timing(
        .clk_pix(clk),
        .rst_pix(rst),
        .frame,
        .sx,
        .sy,
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .de
    );

    tube_4_display tube_mod_1r(
        .clk,
        .in1(t_digit1[0]),
        .in2(t_digit1[1]),
        .in3(t_digit1[2]),
        .in4(t_digit1[3]),
        .dp(dip_1[3:0]),
        .en(ten_1[3:0]),
        .out(tube_1r)
    );

    tube_4_display tube_mod_1l(
        .clk,
        .in1(t_digit1[4]),
        .in2(t_digit1[5]),
        .in3(t_digit1[6]),
        .in4(t_digit1[7]),
        .dp(dip_1[7:4]),
        .en(ten_1[7:4]),
        .out(tube_1l)
    );

    tube_4_display tube_mod_2r(
        .clk,
        .in1(t_digit2[0]),
        .in2(t_digit2[1]),
        .in3(t_digit2[2]),
        .in4(t_digit2[3]),
        .dp(dip_2[3:0]),
        .en(ten_2[3:0]),
        .out(tube_2r)
    );

    tube_4_display tube_mod_2l(
        .clk,
        .in1(t_digit2[4]),
        .in2(t_digit2[5]),
        .in3(t_digit2[6]),
        .in4(t_digit2[7]),
        .dp(dip_2[7:4]),
        .en(ten_2[7:4]),
        .out(tube_2l)
    );

    div10 div11(.in(s_x[0]), .quotient(temps[0]), .remainder(t_digit1[5]));
    div10 div12(.in(temps[0]), .quotient(temps[1]), .remainder(t_digit1[6]));
    div10 div13(.in(temps[1]), .quotient(), .remainder(t_digit1[7]));

    div10 div14(.in(s_y[0]), .quotient(temps[2]), .remainder(t_digit1[2]));
    div10 div15(.in(temps[2]), .quotient(temps[3]), .remainder(t_digit1[3]));
    div10 div16(.in(temps[3]), .quotient(), .remainder(t_digit1[4]));

    div10 div17(.in(number), .quotient(temps[4]), .remainder(t_digit1[0]));
    div10 div18(.in(temps[4]), .quotient(), .remainder(t_digit1[1]));

    div10 div21(.in(t_angle), .quotient(temps[5]), .remainder(t_digit2[0]));
    div10 div22(.in(temps[5]), .quotient(temps[6]), .remainder(t_digit2[1]));
    div10 div23(.in(temps[6]), .quotient(), .remainder(t_digit2[2]));

    div10 div24(.in(s_size[0]), .quotient(temps[7]), .remainder(t_digit2[4]));
    div10 div25(.in(temps[7]), .quotient(temps[8]), .remainder(t_digit2[5]));
    div10 div26(.in(temps[8]), .quotient(), .remainder(t_digit2[6]));

    always_comb begin
        if (s_angle[0] < 0)
            t_angle = s_angle[0] + 360;
        else
            t_angle = s_angle[0];

        if (black)
            r_color = 12'h000;
        else
            r_color = s_color[s_id];

        color_en = (sx >= COLOR_X) && (sy >= COLOR_Y) && (csx < COLOR_SIZE) && (csy < COLOR_SIZE);
        if (swch_3 && color_en) begin
            o_color = c_render;
        end else
            o_color = r_color;

        if (de) begin
            vga_r = o_color[11:8];
            vga_g = o_color[7:4];
            vga_b = o_color[3:0];
        end else begin
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end
    end

    always_comb begin
        if (~swch_6) begin
            tube_l = tube_1l;
            tube_r = tube_1r;
            tube_en = ten_1;
        end else begin
            tube_l = tube_2l;
            tube_r = tube_2r;
            tube_en = ten_2;
        end
    end

    enum { INIT, IDLE, MODE_0, MODE_1, MODE_2, MODE_3, NEXT_SHAPE, DONE } state, next_state;
    always_ff @(posedge clk) state <= #1 next_state;

    always_comb begin
        if (rst) begin
            next_state = INIT;
        end else begin
            case (state)
                INIT: next_state = DONE;
                IDLE: begin
                    if (frame) begin
                        if (swch_1)
                            next_state = MODE_1;
                        else if (swch_2)
                            next_state = MODE_2;
                        else if (swch_3)
                            next_state = MODE_3;
                        else
                            next_state = MODE_0;
                    end else
                        next_state = IDLE;
                end
                MODE_0: next_state = DONE;
                MODE_1: next_state = DONE;
                MODE_2: begin
                    if (c_btn_p)
                        next_state = NEXT_SHAPE;
                    else
                        next_state = DONE;
                end
                MODE_3: next_state = DONE;
                NEXT_SHAPE: next_state = DONE;
                DONE: next_state = IDLE;
                default: next_state = DONE;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        case (state)
            MODE_0: begin
                if (u_btn && (|s_y[0]))   //   |y  iff  y > 0
                    s_y[0] <= s_y[0] - 1;
                else if (d_btn && (s_y[0] < 600 - 1))   // TODO: remove magic number
                    s_y[0] <= s_y[0] + 1;

                if (l_btn && (|s_x[0]))
                    s_x[0] <= s_x[0] - 1;
                else if (r_btn && (s_x[0] < 800 - 1))
                    s_x[0] <= s_x[0] + 1;
            end
            MODE_1: begin
                if (l_btn)
                    s_angle[0] <= p_angle;
                else if (r_btn)
                    s_angle[0] <= n_angle;

                if (u_btn)
                    s_size[0] <= s_size[0] + 1;
                else if (d_btn && (|s_size[0]))
                    s_size[0] <= s_size[0] - 1;

                if (c_btn_p) begin
                    if (s_ty[0] == MAX_TYPE)
                        s_ty[0] <= 0;
                    else
                        s_ty[0] <= s_ty[0] + 1;
                end
            end
            MODE_2: begin
                if (l_btn_p && (|number)) begin
                    number <= number - 1;
                    s_color[number] <= 12'b0;
                end else if (r_btn_p && (number < MAXSHP - 1)) begin
                    s_color[number] <= 12'hFFF;
                    number <= number + 1;
                end
            end
            MODE_3: begin
                if (u_btn && (|cy))
                    cy <= cy - 1;
                else if (d_btn && (cy < COLOR_SIZE - 1))
                    cy <= cy + 1;

                if (l_btn && (|cx))
                    cx <= cx - 1;
                else if (r_btn && (cx < COLOR_SIZE - 1))
                    cx <= cx + 1;

                if (c_btn)
                    s_color[0] <= c_color;
            end
            NEXT_SHAPE: begin
                `include "rtl/control/core_switch_gen.sv.partial"
            end
            INIT: begin  // TODO: add more
                number <= 1;
                cx <= 0;
                cy <= 0;
            end
            DONE: begin
                l_btn_p <= 0;
                r_btn_p <= 0;
                u_btn_p <= 0;
                d_btn_p <= 0;
                c_btn_p <= 0;
            end
            IDLE: begin
                if (l_btn_dn) l_btn_p <= 1;
                if (r_btn_dn) r_btn_p <= 1;
                if (u_btn_dn) u_btn_p <= 1;
                if (d_btn_dn) d_btn_p <= 1;
                if (c_btn_dn) c_btn_p <= 1;
            end
            default: ;
        endcase
    end

endmodule

`resetall
