TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/sin_deg.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = sin_deg
MODULE = test_math_sin_deg

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
