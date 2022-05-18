TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/cos_deg.sv
VERILOG_SOURCES += ../../rtl/math/matrix_multiply.sv
VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
VERILOG_SOURCES += ../../rtl/math/sin_deg.sv
VERILOG_SOURCES += ../../rtl/render/rotate.sv
TOPLEVEL = rotate
MODULE = test_render_rotate

COMPILE_ARGS += -I ../../

include $(shell cocotb-config --makefiles)/Makefile.sim
