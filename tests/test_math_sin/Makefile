TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = sin
MODULE = test_math_sin

COMPILE_ARGS += -I ../../

include $(shell cocotb-config --makefiles)/Makefile.sim
