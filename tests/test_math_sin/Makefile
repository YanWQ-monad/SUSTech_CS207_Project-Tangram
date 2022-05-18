TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/signed_extend.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = sin
MODULE = test_math_sin

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
