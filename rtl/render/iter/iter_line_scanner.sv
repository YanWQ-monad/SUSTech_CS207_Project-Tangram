module iter_line_scanner #(
    parameter CORDW = 9,
    parameter SCREEN_END = 480-1
) (
    input  wire logic clk,             // clock
    input  wire logic rst,             // reset
    input  wire logic start,           // start line drawing
    input  wire logic oe,              // output enable

    output      logic [CORDW-1:0] y,   // drawing position y (which line)
    input  wire logic [CORDW-1:0] x0,  // line interval dependent on y
    input  wire logic [CORDW-1:0] x1,
    output      logic [CORDW-1:0] x,   // drawing position x
    output      logic drawing,         // actively drawing
    output      logic busy,            // drawing request in progress
    output      logic done             // drawing is complete (high for one tick)
);

    logic line_done, line_start;

    iter_hline #(.CORDW(CORDW)) hline(
        .clk,
        .rst,
        .start(line_start),
        .oe,
        .x0,
        .x1,
        .x,
        .drawing,
        .busy(),
        .done(line_done)
    );

    enum {IDLE, LINE_REQ, LINE_DRAW, LINE_DONE} state;

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                done <= 0;
                if (start) begin
                    state <= LINE_REQ;
                    y <= 0;
                    busy <= 1;
                end
            end
            LINE_REQ: begin
                if (x0 <= x1) begin
                    line_start <= 1;
                    state <= LINE_DRAW;
                end else begin
                    state <= LINE_DONE;
                end
            end
            LINE_DRAW: begin
                line_start <= 0;
                if (line_done) begin
                    state <= LINE_DONE;
                end
            end
            LINE_DONE: begin
                if (y == SCREEN_END) begin
                    state <= IDLE;
                    busy <= 0;
                    done <= 1;
                end else begin
                    y <= y + 1;
                    state <= LINE_REQ;
                end
            end
        endcase

        if (rst) begin
            state <= IDLE;
            busy <= 0;
            done <= 0;
        end
    end

endmodule
