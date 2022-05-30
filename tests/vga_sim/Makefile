TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/control/circular_step.sv
VERILOG_SOURCES += ../../rtl/control/core.sv
VERILOG_SOURCES += ../../rtl/control/input_mode.sv
VERILOG_SOURCES += ../../rtl/control/pixel_selector.sv
VERILOG_SOURCES += ../../rtl/input/input_debounce.sv
VERILOG_SOURCES += ../../rtl/math/cos_deg.sv
VERILOG_SOURCES += ../../rtl/math/div10.sv
VERILOG_SOURCES += ../../rtl/math/matrix_multiply.sv
VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
VERILOG_SOURCES += ../../rtl/math/sin_deg.sv
VERILOG_SOURCES += ../../rtl/render/color_map.sv
VERILOG_SOURCES += ../../rtl/render/render_shape.sv
VERILOG_SOURCES += ../../rtl/render/render_shape_basic.sv
VERILOG_SOURCES += ../../rtl/render/rotate.sv
VERILOG_SOURCES += ../../rtl/tube/bcd_to_tube.sv
VERILOG_SOURCES += ../../rtl/tube/tube_4_display.sv
VERILOG_SOURCES += ../../rtl/vga/vga_clock_600p.sv
VERILOG_SOURCES += ../../rtl/vga/vga_timing_600p.sv
VERILOG_SOURCES += ../../rtl/fpga.sv
VERILOG_SOURCES += mock.sv
TOPLEVEL = fpga
MODULE = sim

COMPILE_ARGS += -I ../../

include $(shell cocotb-config --makefiles)/Makefile.sim
