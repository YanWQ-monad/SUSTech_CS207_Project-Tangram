TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/shape/shape_write.sv
TOPLEVEL = shape_write
MODULE = test_shape_write

export PYTHONPATH := ../common:$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim
