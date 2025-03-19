import os
from cocotb.runner import get_runner
from pathlib import Path

# Automated Test Suite for Aeolus CPU

src_path = Path(__file__).resolve().parents[2]  / "src"
   
def test_multiplication_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    
    print(f"Project Path: {src_path}")

    # Initialize lists
    verilog_sources = []
    vhdl_sources = []
    include_dirs = [str(src_path)]  # Ensure it's a list and convert to string

    # Check if the directory exists before proceeding
    if not src_path.exists():
        raise FileNotFoundError(f"Error: Include directory '{src_path}' does not exist!")

    # Add Verilog sources
    if hdl_toplevel_lang == "verilog":
        verilog_file = src_path / "AeolusCPU.v"
        if not verilog_file.exists():
            raise FileNotFoundError(f"Error: Verilog file '{verilog_file}' not found!")

        verilog_sources = [str(verilog_file)]  # Convert to string

    # Get runner and run the build & test
    runner = get_runner(sim)

    runner.build(
        verilog_sources=verilog_sources,
        includes=include_dirs,  # Ensure it's a list
        vhdl_sources=vhdl_sources,
        hdl_toplevel="AeolusCPUTop",
        always=True,
    )

    runner.test(hdl_toplevel="AeolusCPUTop", test_module="test")

#////////////////////////////////////////////////////////////////////////

def test_shifter_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")

    # Initialize lists
    verilog_sources = []
    vhdl_sources = []
    include_dirs = [str(src_path)]  # Ensure it's a list and convert to string

    # Check if the directory exists before proceeding
    if not src_path.exists():
        raise FileNotFoundError(f"Error: Include directory '{src_path}' does not exist!")

    # Add Verilog sources
    if hdl_toplevel_lang == "verilog":
        verilog_file = src_path / "Registers.v"
        if not verilog_file.exists():
            raise FileNotFoundError(f"Error: Verilog file '{verilog_file}' not found!")

        verilog_sources = [str(verilog_file)]  # Convert to string

    # Get runner and run the build & test
    runner = get_runner(sim)

    runner.build(
        verilog_sources=verilog_sources,
        includes=include_dirs, 
        vhdl_sources=vhdl_sources,
        hdl_toplevel="ShiftRegister",
        always=True,
    )
    runner.test(hdl_toplevel="ShiftRegister", test_module="testShifter")

if __name__ == "__main__":
    test_multiplication_runner()
    test_shifter_runner()