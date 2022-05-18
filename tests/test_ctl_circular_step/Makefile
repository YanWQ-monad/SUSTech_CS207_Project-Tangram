TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/control/circular_step.sv
TOPLEVEL = circular_step
MODULE = test_ctl_circular_step

COMPILE_ARGS += -I ../../

include $(shell cocotb-config --makefiles)/Makefile.sim
