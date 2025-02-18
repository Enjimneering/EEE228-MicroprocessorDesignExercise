`include "ALU.v"

module AdderTb();

    reg        CLK;
    reg        RESET;
    reg  [7:0] IN1, IN2;
    wire [7:0] OUT;
    wire       OVERFLOW;

    Adder_8bit uut (CLK, RESET, IN1, IN2, OUT, OVERFLOW);

    initial begin

        $dumpfile("adderdump.vcd");
        $dumpvars(0, "adderTB");
        
        CLK = 0; RESET = 0; IN1 = 0; IN2 = 0; 

        


    end

endmodule