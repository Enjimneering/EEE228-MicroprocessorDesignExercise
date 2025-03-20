
import cocotb
from cocoutil import GenerateClock, posedge

#  DFF (D-Type Flip Flop)
#     inputs: 
#        clk, [3:0] D
#     outputs:
#        [3:0] Q, 

@cocotb.test()
async def TestDFFLoad(dut):
    
    # set initial input values
    dut.D.value = 0

    await GenerateClock(dut)
    
    for dffIN in range(16):
           
        # Set DFF input
        dut.D.value = dffIN
        await posedge(dut.clk) 

        # Assert that output follows the input

        assert dut.Q.value == dffIN
        await posedge(dut.clk) 
       
        # print(f"in value: {getattr(dut, 'in').value}, out value: {dut.out.value}")
            