TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/cos.sv
VERILOG_SOURCES += ../../rtl/math/sin.sv
TOPLEVEL = cos
MODULE = test_cos

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
