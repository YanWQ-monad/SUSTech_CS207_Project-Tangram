TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/render/interval/interval_square.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_hline.sv
VERILOG_SOURCES += ../../rtl/render/iter/iter_line_scanner.sv
VERILOG_SOURCES += test_core.sv
TOPLEVEL = test_core
MODULE = test_render_square

include $(shell cocotb-config --makefiles)/Makefile.sim
