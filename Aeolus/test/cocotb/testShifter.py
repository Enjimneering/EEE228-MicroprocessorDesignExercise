
import cocotb
from cocoutil import GenerateClock, Reset, RunProgram, posedge

# ShiftRegister  
#     inputs: 
#        clk, reset, [3:0] in, loadEnable, [1:0] shiftState,
#     outputs:
#        [7:0] out, flag

@cocotb.test()
async def TestShiftLoad(dut):
    
    # set initial input values
    getattr(dut, "in").value = 0
    dut.loadEnable.value = 1
    dut.shiftState = 0

    await GenerateClock(dut)
    await Reset(dut)
    
    for shiftTestValue in range(16):
            # set inputs
            await posedge(dut.clk) 
            getattr(dut, "in").value =  shiftTestValue

            # measure output
            await posedge(dut.clk) 
            assert dut.out.value == shiftTestValue
            print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")
            
@cocotb.test()
async def TestShiftLeft(dut):

    await GenerateClock(dut)
    await Reset(dut)
    
    # set initial input values
    getattr(dut, "in").value = 0
    dut.loadEnable.value = 1
    dut.shiftState = 2
    
    for shiftTestValue in range(16):
            # set inputs
            dut.loadEnable.value = 1
            getattr(dut, "in").value =  shiftTestValue
            
            await posedge(dut.clk) 
            dut.loadEnable.value = 0
            await posedge(dut.clk)

            # measure output
            await posedge(dut.clk)
            assert dut.out.value == ((shiftTestValue << 1) & 255)
            await posedge(dut.clk)  
            assert dut.out.value == ((shiftTestValue << 1) & 255)
            print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")     
