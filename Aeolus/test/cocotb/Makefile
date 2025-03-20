# Makefile

# paths
ROOTPATH = $(PWD)/../../

# defaults
SIM ?= icarus 
VERBOSE  = 1
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(ROOTPATH)/src/AeolusCPU.v
VERILOG_INCLUDE_DIRS = $(ROOTPATH)/src

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = AeolusCPUTop
# MODULE is the basename of the Python test file
MODULE = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
$(info PATH is $(ROOTPATH))