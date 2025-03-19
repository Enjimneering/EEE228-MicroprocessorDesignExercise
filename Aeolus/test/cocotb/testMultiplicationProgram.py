
import cocotb
from cocoutil import GenerateClock, Reset, RunProgram, posedge

@cocotb.test()
async def TestMultiplication(dut):

    await GenerateClock(dut)
    await Reset(dut)

    for regA in range(16):
        for regB in range(16):
            
            # set inputs
            dut.switches.value = (regA<<4|regB)
            print(f"A: {regA} B: {regB}")

            # run program
            await posedge(dut.clk) 
            await RunProgram(dut)

            # assert output
            print(f"Output: {dut.cpuOut.value}")
            assert dut.cpuOut.value == (regA * regB)
        

    