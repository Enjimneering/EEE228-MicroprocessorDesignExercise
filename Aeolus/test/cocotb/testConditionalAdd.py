@cocotb.test()
async def TestConditionalAdd(dut):
    
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
            