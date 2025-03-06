// CPU Program Execution Testbench

`timescale 1ns/1ps
`include "src/AeolusCPU.v"  
`include "test/macros.v"    // defines assertion macro

/*
    Description:
        This testbench tests the combinational outputs of the ALU by changing
        the control signals and inputs going into the module, and making asseertions
        on the alu output wire. 
    Objectives:
        Test Addition and Subtraction (with overflow/underflow)
        Test AND, OR, XOR and INV functionality
    Success Criteria:
        The test results are visible in the console, if the prgram terminates with
        an assertion error, then  at least one of the logical functions has been implimented 
        incorrectly.
*/

module CPUTb();

    reg        CLK;
    reg        RESET;
    reg  [7:0] SWITCHES;
    wire [7:0] CPU_OUT;

    integer i;

    AeolusCPUTop uut(
        .boardCLK(CLK),
        .reset(RESET),
        .switches(SWITCHES),
        .cpuOut(CPU_OUT)
    );

    initial begin 

        $dumpfile("test/vcd/CPUadddump.vcd");
        $dumpvars(0, CPUTb);
        
        CLK = 1; RESET = 1; SWITCHES[7:0] = 8'b0111_1000; 
        #15 RESET = 0;
        #3300 $display("program complete!"); $finish; 
    end

    always  begin
            #5 CLK = ~CLK;
        end

endmodule

// 1110_0001 = 225