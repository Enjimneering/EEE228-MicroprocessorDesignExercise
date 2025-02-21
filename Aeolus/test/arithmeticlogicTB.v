// Logic Testbench

`timescale 1ns/1ns
`include "src/ALU.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED for CONTROL SIGNAL: %4b at time %0t ns : %m signal  !=  value expected: %5b, got: %5b", CONTROL , $time , value, signal); $finish; end

module ALUTb();

    reg        CLK;
    reg        RESET;
    reg  [3:0] IN1, IN2;
    wire [3:0] ALU_OUT;
    wire       OVERFLOW;
    
    integer i;

    reg [8:0] CONTROL;

    ArithmeticLogicUnit alu( 

    .clk(CLK),
    .reset(RESET),
    .ADD(CONTROL[0]),
    .SUB(CONTROL[1]),
    .LSR(CONTROL[2]),
    .LSH(CONTROL[3]),
    .RSH(CONTROL[4]),
    .AND(CONTROL[5]),
    .OR (CONTROL[6]),
    .XOR(CONTROL[7]),
    .INV(CONTROL[8]),
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

        #5 CONTROL = CONTROL << 1;   // lsr
        $display("Testing LSR Instruction...");
        #15 `assert (alu.sr.dataReg, IN1);
        $display("LSH Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // lsh
        $display("Testing LSH Instruction...");
        #15 `assert (ALU_OUT, (IN1 << 1) );
        $display("LSH Instruction impliemented successfully.");

        #5 CONTROL = CONTROL << 1;   // rsh
        $display("Testing RSH Instruction...");
        #15 `assert (ALU_OUT, (IN1 >> 1) );
        $display("RSH Instruction impliemented successfully.");

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
