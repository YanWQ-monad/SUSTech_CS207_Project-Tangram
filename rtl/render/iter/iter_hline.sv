module iter_hline #(parameter CORDW=10) (
    input  wire logic clk,             // clock
    input  wire logic rst,             // reset
    input  wire logic start,           // start line drawing
    input  wire logic oe,              // output enable
    input  wire logic [CORDW-1:0] x0,  // point 0
    input  wire logic [CORDW-1:0] x1,  // point 1
    output      logic [CORDW-1:0] x,   // drawing position
    output      logic drawing,         // actively drawing
    output      logic busy,            // drawing request in progress
    output      logic done             // drawing is complete (high for one tick)
);

    enum {IDLE, DRAW} state;
    always_comb drawing = (state == DRAW && oe);

    initial begin
        state <= IDLE;
        busy <= 0;
        done <= 0;
    end

    always_ff @(posedge clk) begin
        case (state)
            DRAW: if (oe) begin
                if (x == x1) begin
                    state <= IDLE;
                    busy <= 0;
                    done <= 1;
                end else begin
                    x <= x + 1;
                end
            end
            IDLE: begin
                done <= 0;
                if (start) begin
                    state <= DRAW;
                    x <= x0;
                    busy <= 1;
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
