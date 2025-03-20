import cocotb
from cocotb.triggers import RisingEdge 
from cocotb.triggers import Timer
from cocotb.clock import Clock



def SetDumpFile(dumpfile, dut):
    dut._top_level_dump = dumpfile +".dump"  # Define top-level dump file


def VerifyVerilogSources(_srcPath, _includepath, _verilogFile, _includeFiles):
        
    if not _srcPath.exists():
        raise FileNotFoundError(f"Error: Source directory '{_srcPath}' does not exist!")

    if not _includepath.exists():
        raise FileNotFoundError(f"Error: Include directory '{_includepath}' does not exist!")

    # Verify Verilog sources
    if not _verilogFile.exists():
            raise FileNotFoundError(f"Error: Verilog file '{_verilogFile}' not found!")

    for fileName in _includeFiles:
        verilog_file = _srcPath / fileName
        if not verilog_file.exists():
            raise FileNotFoundError(f"Error: Verilog file '{_includeFiles}' not found!")
                    

# generate 1us clock pulse
async def posedge(signal):
    await RisingEdge(signal)
    await Timer(1, "ns")  # Let the simulator settle updates


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
        