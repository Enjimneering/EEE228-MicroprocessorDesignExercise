
//Subtractor  Testbench
`include "src/ALU.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED in %m: signal != value -> %d != %d", signal, value);  end

module SubtractorTb();

    reg        CLK;
    reg        RESET;
    reg  [3:0] IN1, IN2;
    wire [3:0] OUT;
    wire       OVERFLOW;
    
    integer i;

    CombSubtractor_4bit uut (IN1, IN2, OUT, NEGATIVE);

    initial begin

        $dumpfile("test/vcd/subtractordump.vcd");
        $dumpvars(0, SubtractorTb);
        
        IN1 = 0; IN2 = 0; 

        $display("4-Bit Subtractor Test");
       //$display("   in1   |  in2     |  actual    |  expected");

        for (i = 0; i < 256 ; i = i + 1) begin
            #10 {IN2,IN1} = i[7:0];
            //#5  $display("  %4b    |   %4b  |   %4b   |   %5b   " ,IN1, IN2,  (i[3:0] + i[7:4]) , {OVERFLOW,OUT} );
            #5  `assert({NEGATIVE,OUT}, (i[3:0] - i[7:4]));  // assert that the result is the addition
        end

        $display("TEST SUCCESSFUL!"); $finish; 
    end

endmodule