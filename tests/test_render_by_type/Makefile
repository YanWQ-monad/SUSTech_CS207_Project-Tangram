TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/render/interval/interval_square.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_hline.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_line_scanner.sv
VERILOG_SOURCES += ../../rtl/render/render_by_type.sv
TOPLEVEL = render_by_type
MODULE = test_render_by_type

include $(shell cocotb-config --makefiles)/Makefile.sim
