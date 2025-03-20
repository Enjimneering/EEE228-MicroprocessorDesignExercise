
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
    #dut.shiftState = 2
    
    for shiftTestValue in range(16):
        # set inputs
        dut.loadEnable.value = 1
        dut.shiftState = 0
        getattr(dut, "in").value =  shiftTestValue 
        await posedge(dut.clk)

        dut.loadEnable.value = 0
        dut.shiftState = 2
        await posedge(dut.clk)

        # measure output
        assert dut.out.value == (shiftTestValue<<1) & 255
        print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")

@cocotb.test()
async def TestShiftRight(dut):

    await GenerateClock(dut)
    await Reset(dut)
    
    # set initial input values
    getattr(dut, "in").value = 0
    dut.loadEnable.value = 1
    #dut.shiftState = 2
    
    for shiftTestValue in range(16):
        # set inputs
        dut.loadEnable.value = 1
        dut.shiftState = 0
        getattr(dut, "in").value =  shiftTestValue 
        await posedge(dut.clk)

        dut.loadEnable.value = 0
        dut.shiftState = 1
        await posedge(dut.clk)

        # measure output
        assert dut.out.value == (shiftTestValue>>1) & 255
        print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")

@cocotb.test()
async def TestShiftFlag(dut):

    # Set initial input values
    getattr(dut, "in").value = 0
    dut.loadEnable.value = 1
    dut.shiftState.value = 0

    await GenerateClock(dut)  
    await Reset(dut)  

    # Load initial value into shift register with 1 at LSB
    getattr(dut, "in").value = 0b1001
    await posedge(dut.clk)

    # Perform right shift operation
    dut.shiftState.value = 1
    dut.loadEnable.value = 0
    await posedge(dut.clk)
    dut.shiftState.value = 0

    # Measure output
    assert dut.flag.value == 1, " 1)Shift flag did not set as expected"
    await posedge(dut.clk)

    # Print debug information
    print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}, shift flag: {dut.flag.value}")

    #////////////////////////////// check flag is 1 when load 0b1100
    dut.loadEnable.value = 1
    dut.shiftState.value = 0
    getattr(dut, "in").value = 0b1100
    await posedge(dut.clk)
    assert dut.flag.value == 1, " 2) Shift flag did not set as expected"
    print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}, shift flag: {dut.flag.value}")   
    # Perform left shift operation
    dut.loadEnable.value = 0
    dut.shiftState.value = 2
    getattr(dut, "in").value = 0b1100
    await posedge(dut.clk)
    assert dut.flag.value == 1, " 3)Shift flag did not set as expected"
    assert dut.out.value == getattr(dut, "in").value<<1
    print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}, shift flag: {dut.flag.value}")   
    #////////////////////////////// check flag is 0 when shift right with 0b1110

    dut.loadEnable.value = 1
    dut.shiftState.value = 0
    getattr(dut, "in").value = 0b1110
    await posedge(dut.clk)

    # Perform right shift operation
    dut.loadEnable.value = 0
    dut.shiftState.value = 1
    await posedge(dut.clk)

    # Measure output
    assert dut.flag.value == 0, "4)Shift flag did not set as expected"
    await posedge(dut.clk)

    # Print debug information
    print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}, shift flag: {dut.flag.value}")


