TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = sin
MODULE = test_math_sin

COMPILE_ARGS += -I ../../
export PYTHONPATH := ../common:$(PYTHONPATH)

include $(shell cocotb-config --makefiles)/Makefile.sim
