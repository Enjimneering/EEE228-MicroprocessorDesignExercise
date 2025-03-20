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

def RunTest(_test_name, _src_file, _top_module, _test_file, _src_dir=src_path, _inc_dir=inc_path):
    
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
        hdl_toplevel="_top_module",
        timescale = ("1us","1ns"),
        always=True,
    )
    
    # Run the test 
    
    runner.test(hdl_toplevel=_top_module, test_module=_test_file)
    
    print(f"Finished {_test_name} !")

#  ////////////////////////////////////////////////////////////////////////////// #


#  Test: Multiplication Program
#  DUT:  AeolusCPUTop

def test_multiplication_runner():

    print("Starting multiplication test...")

    # Define Veriilog Sources and Directories

    verilog_filename = "AeolusCPU.v"
    verilog_file = src_path / verilog_filename
    include_dirs = [str(inc_path)] 
    vhdl_sources = []

    # Check if the sources are valid before proceeding 
    
    Verify(src_path, inc_path, verilog_file, "")

    # Get runner and run the build & test
    
    runner = get_runner(sim)

    # Build the test environemnt
    
    runner.build(
        verilog_sources=[str(verilog_file)] ,
        includes=include_dirs,  # Ensure it's a list
        vhdl_sources=vhdl_sources,
        hdl_toplevel="AeolusCPUTop",
        timescale = ("1us","1ns"),
        always=True,
    )
    
    # Run the test 
    
    runner.test(hdl_toplevel="AeolusCPUTop", test_module="testMultiplicationProgram")
    
    print("multiplication test complete!")

#  ////////////////////////////////////////////////////////////////////////////// #

#  Test: Shifter Test Suite 
#  DUT:  Shifter

def test_shifter_runner():
    
    # Define Veriilog Sources and Directories

    verilog_filename = "Registers.v"
    verilog_file = src_path / verilog_filename
    include_dirs = [str(inc_path)] 
    vhdl_sources = []

    # Check if the sources are valid before proceeding 
    
    Verify(src_path, inc_path, verilog_file, "")

    # Get runner 

    runner = get_runner(sim)

    # Build the test environemnt

    runner.build(
        verilog_sources=[str(verilog_file)],
        includes=include_dirs, 
        vhdl_sources=vhdl_sources,
        timescale = ("1us","1ns"),
        hdl_toplevel="ShiftRegister",
        always=True
    )
    runner.test(hdl_toplevel="ShiftRegister", test_module="testShifter")

# ////////////////////////////////////////////////////////////////////////////// #

def test_dff_runner():

    print("Starting DFF test...")

   # Define Veriilog Sources and Directories

    verilog_filename = "Registers.v"
    verilog_file = src_path / verilog_filename
    include_dirs = [str(inc_path)] 
    vhdl_sources = []

    # Check if the sources are valid before proceeding 
    
    Verify(src_path, inc_path, verilog_file, "")

    # Get runner and run the build & test
    runner = get_runner(sim)

    runner.build(
        verilog_sources=verilog_file,
        includes=include_dirs, 
        vhdl_sources=vhdl_sources,
        hdl_toplevel="AeolusCPUTop",
        timescale = ("1us","1ns"),
        always=True,
    )

    runner.test(hdl_toplevel="AeolusCPUTop", test_module="testMultiplicationProgram")
    
    print("multiplication test complete...")

# ///////////////////////////////////////////////////////////////////////////// #

if __name__ == "__main__":
    RunTest(
        "Multiplication Test Program",
        _test_name,
        _src_file="",
        _top_module="", 
        _test_file=""
     )
    test_shifter_runner()
