
import cocotb
from cocoutil import GenerateClock, posedge, Reset
import random

#  Reset Enable DFF (D-Type Flip Flop)
#     inputs: 
#        clk, reset, enable [3:0] D
#     outputs:
#        [3:0] Q, 

@cocotb.test()
async def TestDFFLoad(dut):
    
    # set initial input values
    dut.D.value = 0
    dut.enable.value = 0
    dut.reset.value = 0
    dut.Q.value = 0

    await GenerateClock(dut)
    
    # ensure no values pass throuh
    for dffIN in range(16):
           
        # Set DFF input
        dut.D.value = dffIN
        await posedge(dut.clk) 

        # Assert that output follows the input

        assert dut.Q.value == 0
        await posedge(dut.clk) 
       
        # print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")
            
      # ensure no values pass throuh

    dut.enable.value = 1

    for dffIN in range(16):
           
        # Set DFF input
        dut.D.value = dffIN
        await posedge(dut.clk) 

        # Assert that output follows the input

        assert dut.Q.value == 0
        await posedge(dut.clk) 
       
        # print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")


@cocotb.test()
async def TestDFFReset(dut):
    
    # set initial input values
    dut.D.value = 0
    dut.Q.value = random.randint(0,15)
    dut.reset.value = 0
    dut.enable.value = 0

    await GenerateClock(dut)

    dut.reset.value=1
    await posedge(dut.clk)

    # Assert that output follows the input

    assert dut.Q.value == 0
    await posedge(dut.clk) 
       
    # print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")   
   
