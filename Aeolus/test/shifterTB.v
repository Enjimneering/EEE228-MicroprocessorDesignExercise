// Shifter Testbench

`timescale 1ns/1ns
`include "src/ALU.v"

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED in test %4b at time %0t ns : %m signal  !=  value expected: %5b, got: %5b", i[3:0], $time , value, signal); $finish;  end

module ShifterTb();

    reg        CLK;
    reg        RESET;
    reg  [3:0] IN1;
    reg        LOAD_ENABLE;
    reg        LSH;
    reg        RSH;
    wire [3:0] OUT;
    wire       FLAG;
    
    integer i;

    ShiftRegister uut (CLK,IN1,LOAD_ENABLE, {LSH,RSH}, OUT, FLAG);

    initial begin

        $dumpfile("test/vcd/shifterdump.vcd");
        $dumpvars(0, ShifterTb);
        
        CLK = 0; IN1 = 0; LOAD_ENABLE = 0; LOAD_ENABLE = 0; LSH = 0; RSH = 0; 

        $display("4-Bit Shifter Test");

        //$display("   in1   |  in2     |  actual    |  expected");

        // Test LDS

        #10 LOAD_ENABLE = 1;
        $display("LDS TEST");
        i = 4'b0010;
        #5  {IN1} = i[3:0];
        
        $display("RSH TEST");
        #10 RSH = 1;
        #5  `assert({uut.dataReg}, (4'b0001));
        #5  `assert({FLAG}, (0));
        
        $display("RSH TEST");
        #10 RSH = 1;
        #5  `assert({uut.dataReg}, (4'b0000));
        #5  `assert({FLAG}, (1));
        
        #10 LOAD_ENABLE = 1;
        $display("LDS TEST");
        i = 4'b0010;
        #5  {IN1} = i[3:0];





        for (i = 0; i < 16 ; i = i + 1) 
        begin
            #5  {IN1} = i[3:0];
            #5  `assert({uut.dataReg}, (i[3:0]));  // assert that the result is the shift
        end
        $display("Test Completed!");

        // Test LSH
        $display("LSH TEST");
        #10 LSH = 1; IN1 = 0;

        for (i = 0; i < 16 ; i = i + 1) begin
            #5 {IN1} = i[3:0];
            //#5  $display("  %4b    |   %4b  |   %4b   |   %5b   " ,IN1, IN2,  (i[3:0] + i[7:4]) , {OVERFLOW,OUT} );
            #15 `assert({FLAG,OUT}, (i[3:0] << 1 ));  // assert that the result is LSH after 1 cycle
        end
        $display("Test Completed!");

        // Test RSH
                
         $display("RSH TEST");
            #10 IN1 = 0;
            #10 LSH = 0; RSH = 1;

        for (i = 0; i < 16 ; i = i + 1) begin
            #5 {IN1} = i[3:0];
            //#5  $display("  %4b    |   %4b  |   %4b   |   %5b   " ,IN1, IN2,  (i[3:0] + i[7:4]) , {OVERFLOW,OUT} );
            #15 `assert({FLAG,OUT}, (i[3:0] >> 1));  // assert that the result is RSH after 1 cycle
        end
        

        $display("TEST SUCCESSFUL!"); $finish; 

    end

    always  begin
        #5 CLK = ~CLK;
    end

endmodule