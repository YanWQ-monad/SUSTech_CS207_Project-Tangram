`resetall
`timescale 1ns / 1ps
`default_nettype none

module vga_display #(
    parameter ADDRW = 20,
    parameter DATAW = 12,
    parameter CORDW = 10,
    parameter COLRW = 4
) (
    input  wire logic clk,  // 100MHz clock
    input  wire logic rst,  // reset

    // RAM
    input  wire logic [ADDRW-1:0] ram_address_offset,  // buffer offset, used in double buffer
    output      logic [ADDRW-1:0] ram_address,         // read address
    output      logic             ram_enable,          // read enable
    input  wire logic [DATAW-1:0] ram_data,            // read data

    // VGA output
    output      logic vga_hsync,          // VGA horizontal sync
    output      logic vga_vsync,          // VGA vertical sync
    output      logic [COLRW-1:0] vga_r,  // 4-bit VGA red
    output      logic [COLRW-1:0] vga_g,  // 4-bit VGA green
    output      logic [COLRW-1:0] vga_b   // 4-bit VGA blue
);

    // Debug only
    logic vga_de;

    initial vga_hsync = 1;
    initial vga_vsync = 1;

    logic clk_pix;
    logic clk_pix_locked;

    vga_clock_480p clock(
        .clk_100m(clk),
        .rst,
        .clk_pix,
        .clk_pix_locked
    );

    logic [CORDW-1:0] sx, sy;
    logic hsync, vsync, de;
    vga_timing_480p timing(
        .clk_pix,
        .rst_pix(!clk_pix_locked),
        .sx,
        .sy,
        .hsync,
        .vsync,
        .de
    );

    logic [CORDW-1:0] i_sx, i_sy;
    logic i_hsync = 1, i_vsync = 1, i_de = 0;

    logic [ADDRW-1:0] id;
    vga_pixel_id mapper(
        .x(i_sx),
        .y(i_sy),
        .id
    );

    // data flow: timing -> internal -> vga
    // and "internal" is used to fetch data from memory

    enum {RAM_PREPARE, RAM_READING, RAM_IDLE} state, state_next;
    logic [DATAW-1:0] data;
    logic ram_trigger;

    always_ff @(posedge clk_pix) begin
        vga_hsync <= i_hsync;
        vga_vsync <= i_vsync;
        vga_de <= i_de;
        if (i_de) begin
            vga_r <= ram_data[3:0];
            vga_g <= ram_data[7:4];
            vga_b <= ram_data[11:8];
        end else begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end

        i_sx <= sx;
        i_sy <= sy;
        i_de <= de;
        i_hsync <= hsync;
        i_vsync <= vsync;
        ram_trigger <= 1;
    end

    always_comb begin
        case (state)
            RAM_PREPARE: state_next = RAM_READING;
            RAM_READING: state_next = RAM_IDLE;
            RAM_IDLE: state_next = (ram_trigger === 1) ? RAM_PREPARE : RAM_IDLE;
        endcase
    end

    always_ff @(posedge clk) state <= state_next;

    always_ff @(posedge clk) begin
        case (state)
            RAM_PREPARE: begin
                ram_address <= ram_address_offset + id;
                ram_enable <= i_de;
            end
            RAM_READING: begin
                data <= ram_data;
                ram_enable <= 0;
                ram_trigger <= 0;
            end
            RAM_IDLE: ram_enable <= 0;
        endcase
    end

endmodule

`resetall
