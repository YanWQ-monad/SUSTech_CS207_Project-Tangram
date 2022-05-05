`resetall
`timescale 1ns / 1ps
`default_nettype none

module basic_square_control #(
    parameter DATAB = 3,   // data bits, 2^3 = 8
    parameter CORDW = 10,
    parameter ADDRW = 20,
    parameter DATAW = 12,
    parameter NUMW = DATAW
) (
    input  wire logic clk,
    input  wire logic rst,
    input  wire logic trigger,

    input  wire logic l_btn,
    input  wire logic r_btn,
    input  wire logic u_btn,
    input  wire logic d_btn,

    output      logic [ADDRW-1:0] ram_address,         // ram address
    output      logic             ram_enable,          // ram enable
    output      logic             ram_we,              // ram write enable
    input  wire logic [DATAW-1:0] ram_dout,            // ram read data
    output      logic [DATAW-1:0] ram_din,             // ram write data

    output      logic busy
);

    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter BUFFER_SIZE = SCREEN_WIDTH * SCREEN_HEIGHT;

    logic [DATAW-1:0] ty, size, rotate;
    logic [CORDW-1:0] x, y;

    initial begin
        ty = 0;
        x = 0;
        y = 0;
        size = 0;
        rotate = 0;
    end

    logic [CORDW-1:0] draw_x, draw_y;
    logic [ADDRW-1:0] draw_id;
    logic draw_start, draw_done, draw_working;

    render_by_type render(
        .clk,
        .rst,

        .ty,
        .x0(x),
        .y0(y),
        .size,

        .start(draw_start),
        .y(draw_y),
        .x(draw_x),
        .drawing(draw_working),
        .busy(),
        .done(draw_done)
    );

    vga_pixel_id mapper(
        .id(draw_id),
        .x(draw_x),
        .y(draw_y)
    );

    logic [CORDW-1:0] read_x, read_y;
    logic [DATAW-1:0] read_ty, read_size, read_rotate, read_data;
    logic [ADDRW-1:0] read_address;
    logic read_enable, read_trigger, read_busy;
    shape_read read(
        .clk,
        .rst,
        .id(12'b0),
        .trigger(read_trigger),

        .ram_address_offset(20'(BUFFER_SIZE * 2)),
        .ram_address(read_address),
        .ram_enable(read_enable),
        .ram_data(read_data),

        .busy(read_busy),
        .ty(read_ty),
        .x(read_x),
        .y(read_y),
        .size(read_size),
        .rotate(read_rotate)
    );

    logic [CORDW-1:0] write_x, write_y;
    logic [DATAW-1:0] write_ty, write_size, write_rotate, write_data;
    logic [ADDRW-1:0] write_address;
    logic write_enable, write_trigger, write_busy;
    shape_write write(
        .clk,
        .rst,
        .id(12'b0),
        .trigger(write_trigger),

        .ram_address_offset(20'(BUFFER_SIZE * 2)),
        .ram_address(write_address),
        .ram_enable(write_enable),
        .ram_data(write_data),

        .busy(write_busy),
        .ty(write_ty),
        .x(write_x),
        .y(write_y),
        .size(write_size),
        .rotate(write_rotate)
    );

    enum { IDLE, CLEAN, READ, WORK, WORK_DONE, WRITE, RENDER } state;

    always_comb busy = state != IDLE;

    // connect RAM wires
    always_comb begin
        case (state)
            READ: begin
                ram_address = read_address;
                ram_enable = read_enable;
                ram_we = 0;
                ram_din = 12'bx;
                read_data = ram_dout;
            end
            WRITE: begin
                ram_address = write_address;
                ram_enable = write_enable;
                ram_we = write_enable;
                ram_din = write_data;
            end
            CLEAN, RENDER: begin
                ram_address = draw_id + BUFFER_SIZE;
                ram_enable = draw_working;
                ram_we = draw_working;
                ram_din = (state == RENDER) ? 12'hFFF : 12'h000;
            end
            default: begin
                ram_address = 20'bx;
                ram_enable = 0;
                ram_we = 0;
                ram_din = 12'bx;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                if (trigger) begin
                    draw_start <= 1;
                    state <= CLEAN;
                end
            end
            CLEAN: begin
                if (draw_start) begin
                    draw_start <= 0;
                end else if (draw_done) begin
                    state <= READ;
                    read_trigger <= 1;
                end
            end
            READ: begin
                if (read_trigger) begin
                    read_trigger <= 0;
                end else if (!read_busy) begin
                    state <= WORK;
                    ty <= read_ty;
                    x <= read_x;
                    y <= read_y;
                    size <= read_size;
                    rotate <= read_rotate;
                end
            end
            WORK: begin
                if (l_btn && (x > 0)) begin
                    x <= x - 1;
                end else if (r_btn && (x < SCREEN_WIDTH)) begin
                    x <= x + 1;
                end else if (u_btn && (y > 0)) begin
                    y <= y - 1;
                end else if (d_btn && (y < SCREEN_HEIGHT)) begin
                    y <= y + 1;
                end

                state <= WORK_DONE;
            end
            WORK_DONE: begin
                state <= WRITE;
                write_trigger <= 1;
                write_ty <= ty;
                write_x <= x;
                write_y <= y;
                write_size <= size;
                write_rotate <= rotate;
            end
            WRITE: begin
                if (write_trigger) begin
                    write_trigger <= 0;
                end else if (!write_busy) begin
                    state <= RENDER;
                    draw_start <= 1;
                end
            end
            RENDER: begin
                if (draw_start) begin
                    draw_start <= 0;
                end else if (draw_done) begin
                    state <= IDLE;
                end
            end
        endcase

        if (rst) begin
            state <= IDLE;
            draw_start <= 0;
            write_trigger <= 0;
            read_trigger <= 0;
        end
    end

endmodule

`resetall
