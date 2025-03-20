import os
from cocotb.runner import get_runner
from pathlib import Path
from cocoutil import VerifyVerilogSources as Verify

# Automated Test Suite for Aeolus CPU

# =========== TEST ENVIRONMENT VARIABLES =========== #

hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
sim = os.getenv("SIM", "icarus")
src_path = Path(__file__).resolve().parents[2]  / "src"
inc_path = src_path

# ==================================================== #


# ////////////////////////////////////////////////////////////////////////////// #

def RunTest(_test_name, _src_file, _top_module, _test_file, _src_dir=src_path, _inc_dir=inc_path, _dump_file="dump.vcd", _run=1):
    
    if (_run == 1):

        print(f"Starting {_test_name}...")

        verilog_filename = _src_file
        verilog_file = _src_dir / verilog_filename
        include_dirs = [str(_inc_dir)] 
        vhdl_sources = []

        # Check if the sources are valid before proceeding 
        
        Verify(src_path, inc_path, verilog_file, "")

        # Get runner and run the build & test
        
        runner = get_runner(sim)

        # Build the test environemnt
        
        runner.build(
            verilog_sources=[str(verilog_file)],
            includes=include_dirs,  # Ensure it's a list
            vhdl_sources=vhdl_sources,
            hdl_toplevel=_top_module,
            timescale = ("1us","1ns"),
            always=True,
        )   
        
        # Run the test 
        
        runner.test(hdl_toplevel=_top_module, test_module=_test_file)
        
        print(f"Finished {_test_name}!")

    else:
        print(f"Skipped {_test_name}.")
        return
        
# ////////////////////////////////////////////////////////////////////////////// #


if __name__ == "__main__":
   
    # ///////////////////////////////////////////////////#

    #  Test: Multiplication Program
    #  DUT:  AeolusCPUTop
    
    RunTest (
         _test_name="CPU Tests",
         _src_file="AeolusCPU.v",
         _top_module="AeolusCPUTop", 
         _test_file="testMultiplicationProgram",
         _run=0
    )
   
    # ///////////////////////////////////////////////////#

    #  Test: Shifter Test Suite 
    #  DUT:  Shifter

    RunTest(
         _test_name="Shifter Tests",
         _src_file="Registers.v",
         _top_module="ShiftRegister", 
         _test_file="testShifter",
         _run=1
    )

    # ///////////////////////////////////////////////////#

    #  Test: DFF tests
    #  DUT:  DFF

    RunTest(
         _test_name="DFF Tests",
         _src_file="Registers.v",
         _top_module="DFF", 
         _test_file="testDFF",
         _run=0
    )

   
    # ///////////////////////////////////////////////////#

    #  Test: Reset-Enable DFF tests
    #  DUT:  ResetEnableDFF

    RunTest(
         _test_name="(Reset Enable) DFF Tests",
         _src_file="Registers.v",
         _top_module="DFF", 
         _test_file="testREDFF",
         _run=0
    )

   
    # ///////////////////////////////////////////////////#
   

   



