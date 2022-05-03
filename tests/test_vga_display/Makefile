TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += ../../rtl/vga/vga_clock_480p.sv
VERILOG_SOURCES += ../../rtl/vga/vga_display.sv
VERILOG_SOURCES += ../../rtl/vga/vga_pixel_id.sv
VERILOG_SOURCES += ../../rtl/vga/vga_timing_480p.sv
TOPLEVEL = vga_display
MODULE = test_vga_display

include $(shell cocotb-config --makefiles)/Makefile.sim
