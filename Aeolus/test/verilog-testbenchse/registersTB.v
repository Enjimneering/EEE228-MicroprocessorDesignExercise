`timescale 1ns/1ns
`include "src/Registers.v" 

module RegistersTb();

    reg         CLK;
    reg         RESET;
    reg         ENABLE;
    reg  [3:0]  IN;
    wire [3:0]  OUT;

    ResetEnableDFF uut (CLK, RESET, ENABLE, IN, OUT);

    initial begin   
        
        $dumpfile("test/vcd/registersdump.vcd");
        $dumpvars(0, RegistersTb);
    
        // Test the Reset

        CLK = 1; IN = 9; RESET = 1; ENABLE = 0; 
        
        // Test that out stays at zero
        #10 @(posedge CLK) begin
            RESET = 0;
        end
        
        // test out goes to 9
         #10 @(posedge CLK) begin
            ENABLE = 1;
        end

        // test ouut goes to 10
        #10  @(posedge CLK) begin
            IN = 10;
        end

       #10 @(posedge CLK) begin
            IN = 14;
        end


        #100 $finish;
    end

    always begin
        #5 CLK = ~CLK;
    end

    
endmodule