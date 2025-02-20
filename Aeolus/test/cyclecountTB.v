// Logic Testbench

`timescale 1ns/1ns
`include "src/Control.v"
`include "src/ALU.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED for OPCODE: %4b at time %0t ns : %m signal  !=  value expected: %5b, got: %5b", OPCODE , $time , value, signal); $finish; end

module CPUaddTb();

    reg        CLK;
    reg        INSTRUCTIONDONE;
    reg  [7:0] SWITCHES;
    wire [3:0] CPU_OUT;

    integer i;


    wire fetch;

    CycleCounter cc (
        .clk(CLK),
        .opcode(opcode),
        .instructionFinished(fetch)

    );

    // Program Counter 
    wire [3:0] PCin;
    wire [3:0] PCout;
    wire PCoverflow;
    reg [3:0] incrementValue;
    
    ResetEnableDFF_4bit PC (clk, reset, 1'b1, PCin, PCout);
    
    CombAdder_4bit inc (PCout, incrementValue , PCin, PCoverflow ); 

    always @(*) begin
        if (fetch) begin
            incrementValue = 1;
        end else begin
            incrementValue = 0;
        end

    end


    wire [3:0] opcode;

    ProgramROM rom (clk, PCout, opcode);

    // instruction decoder
    InstructionDecoder decoder (
        .instructionIn(opcode),
        .LDA  (_LDA),
        .LDB  (_LDB),
        .LDO  (_LDO),
        .LDSA (_LDSA),
        .LDSB (_LDSB),
        .LSH  (_LSH),
        .RSH  (_RSH),
        .CLR  (_CLR),
        .SNZA (_SNZA),
        .SNZS (_SNZS),
        .ADD  (_ADD),
        .SUB  (_SUB),
        .AND  (_AND),
        .OR   (_OR),
        .XOR  (_XOR),
        .INV  (_INV)
    );

    initial begin

        $dumpfile("test/vcd/CPUadddump.vcd");
        $dumpvars(0, CPUaddTb);
        
        CLK = 1; RESET = 1; SWITCHES[7:0] = 8'b0111_0001; 
        #20 RESET = 0;
        
        #1000 RESET = 1;
        #100 $display("program complete!"); $finish; 
    end

    always  begin
            #5 CLK = ~CLK;
        end

endmodule
