TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/cos_deg.sv
VERILOG_SOURCES += ../../rtl/math/radians.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = cos_deg
MODULE = test_math_cos_deg

COMPILE_ARGS += -I ../../

include $(shell cocotb-config --makefiles)/Makefile.sim
