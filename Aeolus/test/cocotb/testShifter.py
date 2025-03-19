
import cocotb
from cocoutil import GenerateClock, Reset, RunProgram, posedge

# ShiftRegister  
#     inputs: 
#        clk, reset, [3:0] in, loadEnable, [1:0] shiftState,
#     outputs:
#        [7:0] out, flag

@cocotb.test()
async def TestShifter(dut):

    await GenerateClock(dut)
    await Reset(dut)

    for shiftTestValue in range(16):
            # set inputs
            
            print(f"ShiftTestValue: {shiftTestValue}")
            # run program
            await posedge(dut.clk) 
            await RunProgram(dut)

            # assert output
            print(f"Output: {dut.out.value}")
            assert dut.out.value == (ShiftTestValue )
        

    