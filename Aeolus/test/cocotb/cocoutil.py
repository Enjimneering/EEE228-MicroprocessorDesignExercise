import cocotb
from cocotb.triggers import RisingEdge as posedge
from cocotb.triggers import Timer
from cocotb.clock import Clock

# generate 1us clock pulse
async def GenerateClock(dut):
    # generate clk
    clk = Clock(dut.clk, 1, "us")
    cocotb.start_soon(clk.start(None, True)) 
# reset module
async def Reset(dut):
    # reset module clk
    dut.reset.value = 1
    await posedge(dut.clk) 
    await posedge(dut.clk) 
    dut.reset.value = 0

async def RunProgram(dut):
    while (dut.PCout.value != 0):
        await posedge(dut.clk)
        