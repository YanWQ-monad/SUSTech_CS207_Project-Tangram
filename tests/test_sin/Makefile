TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = sin
MODULE = test_sin

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
