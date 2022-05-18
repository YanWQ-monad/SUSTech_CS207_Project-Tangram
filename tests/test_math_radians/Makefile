TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/radians.sv
TOPLEVEL = radians
MODULE = test_math_radians

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
