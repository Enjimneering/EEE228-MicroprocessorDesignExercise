// Logic Testbench

`timescale 1ns/1ns
`include "src/ALU.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED in %m: signal != value -> %d != %d", signal, value);  end

module LogicTb();

    reg        CLK;
    reg        RESET;
    reg  [3:0] IN1, IN2;
    wire [3:0] AND_OUT, OR_OUT, XOR_OUT;
    wire       OVERFLOW;
    
    integer i;

    And_4bit a (IN1, IN2, AND_OUT);
    Or_4bit o  (IN1, IN2, OR_OUT);
    Xor_4bit x (IN1, IN2, XOR_OUT);

    initial begin

        $dumpfile("test/vcd/logicgatesdump.vcd");
        $dumpvars(0, LogicTb);
        
        IN1 = 0; IN2 = 0; 

        $display("4-Bit Logic Gates Test");

       //$display("   in1   |  in2     |  actual    |  expected");

        for (i = 0; i < 256 ; i = i + 1) begin

            #10 {IN2, IN1} = i[7:0];
            //#5  $display("  %4b    |   %4b  |   %4b   |   %5b   " ,IN1, IN2,  (i[3:0] + i[7:4]) , {OVERFLOW,OUT} );
            #5  `assert({AND_OUT}, (i[3:0] & i[7:4]));    // assert that the result is the AND operation
                `assert({OR_OUT},  (i[3:0] | i[7:4]));    // assert that the result is the OR operation
                `assert({XOR_OUT}, (i[3:0] ^ i[7:4]));    // assert that the result is the XOR operation
        end

        $display("TEST SUCCESSFUL!"); $finish; 
    end

endmodule