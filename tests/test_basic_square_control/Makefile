TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/render/interval/interval_square.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_hline.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_line_scanner.sv
VERILOG_SOURCES += ../../rtl/render/render_by_type.sv
VERILOG_SOURCES += ../../rtl/control/basic_square_control.sv
VERILOG_SOURCES += ../../rtl/shape/shape_read.sv
VERILOG_SOURCES += ../../rtl/shape/shape_write.sv
VERILOG_SOURCES += ../../rtl/vga/vga_pixel_id.sv
TOPLEVEL = basic_square_control
MODULE = test_basic_square_control

export PYTHONPATH := ../common:$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim
