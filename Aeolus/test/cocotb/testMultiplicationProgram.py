
import cocotb
from cocoutil import GenerateClock, Reset, RunProgram, posedge, SetDumpFile

# AeolusCPU  
#     inputs: 
#        clk, reset, [7:0] switches],
#     outputs:
#        [7:0] CPUOut, 

@cocotb.test()
async def TestMultiplicationAlgorithm(dut):

    dut.switches.value = 0

    await GenerateClock(dut)
    await Reset(dut)

    for regA in range(16):
        for regB in range(16):
            
            # set switches value
            dut.switches.value = (regA<<4|regB)
            # print(f"A: {regA} B: {regB}")
            await posedge(dut.clk)

            # run program in ROM (wait till PC wraps round)
            
            await RunProgram(dut)

            # assert that output = in1 * in2

            assert dut.cpuOut.value == (regA * regB)
           # print(f"Output: {dut.cpuOut.value}")
        

    