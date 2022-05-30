TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/cos_deg.sv
VERILOG_SOURCES += ../../rtl/math/matrix_multiply.sv
VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
VERILOG_SOURCES += ../../rtl/math/sin_deg.sv
VERILOG_SOURCES += ../../rtl/render/rotate.sv
VERILOG_SOURCES += ../../rtl/render/render_shape.sv
VERILOG_SOURCES += ../../rtl/render/render_shape_basic.sv
TOPLEVEL = render_shape
MODULE = test_render_shape

COMPILE_ARGS += -I ../../
export PYTHONPATH := ../common:$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim
