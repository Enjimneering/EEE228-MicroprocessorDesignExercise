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
    wire [7:0] OUT;
    wire       FLAG;
    
    reg  [3:0] D;
    wire [3:0] Q;
    integer    i; 

    ShiftRegister uut (CLK, RESET, IN1, LOAD_ENABLE, {LSH,RSH}, OUT, FLAG);

    initial begin

        $dumpfile("test/vcd/shifterdump.vcd");
        $dumpvars(0, ShifterTb);
        
        CLK = 1; RESET = 1; IN1 = 4'b1111; 
        LOAD_ENABLE = 0; LSH = 0; RSH = 0; 
        #5 RESET = 0;

        // Test for LDS

        @(posedge CLK) begin
            LOAD_ENABLE = 1;
        end

        #5 @(posedge CLK) begin
            IN1 = 4'b1101 ;
        end

        #5 @(posedge CLK) begin
            IN1 = 4'b1001 ;
        end

        #5  @(posedge CLK) begin
            IN1 = 4'b1000 ;
        end

        // Test for RSH
        
        #5 @(posedge CLK) begin
            RSH = 1; 
            LOAD_ENABLE = 0;
        end

        // test for LSH
        #40 @(posedge CLK) begin
            LSH = 1; 
            RSH = 0;
            LOAD_ENABLE = 0;
        end

        #5 @(posedge CLK) begin
            RSH = 1; 
            LSH = 0;
        end
        
        #40 $finish;

    end

    always begin
        #5 CLK = ~CLK;
    end

endmodule