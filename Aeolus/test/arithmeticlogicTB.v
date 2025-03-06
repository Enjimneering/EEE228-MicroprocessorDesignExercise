// Arithmetic Logic Unit Testbench

`timescale 1ns/1ns
`include "src/ALU.v"     // contains ALU module
`include "test/macros.v" // defines assert macro

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

module ALUTb();

    reg        CLK;
    reg        RESET;   // todo: impliment/test reset functionality?
    reg  [3:0] IN1, IN2;
    wire [3:0] ALU_OUT;
    wire       OVERFLOW;
    
    integer i;

    reg [6:0] CONTROL;

    ArithmeticLogicUnit alu ( 
        .clk(CLK),
        .reset(RESET),
        .ADD(CONTROL[0]),
        .SUB(CONTROL[1]),
        .AND(CONTROL[2]),
        .OR (CONTROL[3]),
        .XOR(CONTROL[4]),
        .INV(CONTROL[5]),
        .in1(IN1),  
        .in2(IN2), 
        .out(ALU_OUT),
        .overflow(OVERFLOW)
    );

    initial begin

        $dumpfile("test/vcd/arithmeticlogicdump.vcd");
        $dumpvars(0, ALUTb);
        
        CLK = 1; IN1 = 4'b0111; IN2 = 4'b0101; CONTROL = 0; 

        #15 $display("ALU TEST");
        CONTROL = 1;
        $display("Testing ADD Instruction..."); 
        #10 `assert (ALU_OUT, (IN1 + IN2))
        $display("ADD Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;    // sub
        $display("Testing SUB Instruction...");
        #15 `assert (ALU_OUT, (IN1 - IN2))
        $display("SUB Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // and
        $display("Testing AND Instruction...");
        #15 `assert (ALU_OUT, (IN1[3:0] & IN2[3:0]));
        $display("AND Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // or
        $display("Testing OR Instruction...");
        #15 `assert (ALU_OUT, (IN1[3:0] | IN2[3:0]) );
        $display("OR Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // xor
        $display("Testing XOR Instruction...");
        #15 `assert (ALU_OUT, (IN1[3:0] ^ IN2[3:0]));
        $display("XOR Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // inv
        $display("Testing INV Instruction...");
        #15 `assert (ALU_OUT, (~IN1[3:0]));
        $display("INV Instruction impliemented successfully.");

        $display("ALL TESTS SUCCESSFUL!"); $finish; 
    end

    always  begin
            #5 CLK = ~CLK;
        end

endmodule
