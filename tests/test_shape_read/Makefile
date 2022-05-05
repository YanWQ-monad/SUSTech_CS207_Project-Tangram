TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/shape/shape_read.sv
TOPLEVEL = shape_read
MODULE = test_shape_read

export PYTHONPATH := ../common:$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim
