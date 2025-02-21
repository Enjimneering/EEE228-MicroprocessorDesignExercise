SRC ?= cpuTB
VVP  ?= test.vvp

all:
	
	iverilog -o test/vcd/$(VVP).vvp test/$(SRC).v 
	vvp test/vcd/$(VVP).vvp
