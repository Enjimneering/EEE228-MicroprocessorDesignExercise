// Logic Testbench

`timescale 1ns/1ns
`include "src/Top.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED for OPCODE: %4b at time %0t ns : %m signal  !=  value expected: %5b, got: %5b", OPCODE , $time , value, signal); $finish; end

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
        
        CLK = 1; RESET = 1; SWITCHES[7:0] = 8'b1100_0010; 
        #20 RESET = 0;
        #3300 $display("program complete!"); $finish; 
    end

    always  begin
            #5 CLK = ~CLK;
        end

endmodule
