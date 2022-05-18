TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/signed_extend.sv
TOPLEVEL = radians
MODULE = test_math_radians

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
