TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/math/matrix_multiply.sv
TOPLEVEL = matrix_multiply
MODULE = test_math_matrix_multiply

COMPILE_ARGS += -I ../../rtl/math/

include $(shell cocotb-config --makefiles)/Makefile.sim
