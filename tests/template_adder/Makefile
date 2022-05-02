# LDFLAGS += -undefined dynamic_lookup -v

# SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/_template/adder.sv
TOPLEVEL = adder
MODULE = test_template_adder

include $(shell cocotb-config --makefiles)/Makefile.sim
