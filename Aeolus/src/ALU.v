// Arithmetic Logic Unit

`include "Registers.v"

// Arithmetic Unit Components
/*
               Arithmetic Unit
            /         |         \
        4bitAdder 4bitSubtractor 4bitShifter
        
*/

module ArithmeticLogicUnit (
    input            ADD,
    input            SUB,
    input wire       AND,
    input wire       OR,
    input wire       XOR,
    input wire       INV,
    input wire       CLR,
    input wire [DATA_WIDTH-1:0] in1,
    input wire [DATA_WIDTH-1:0] in2, 
    output reg [DATA_WIDTH-1:0] out,
    output reg       overflow

);
    parameter DATA_WIDTH = 8;

    wire [7:0] adderOut, subtractorOut;
    wire adderOverflowFlag, subtractorOverflowFlag;
    wire [3:0] andOut;
    wire [3:0] orOut;
    wire [3:0] xorOut;
    wire [3:0] notOut;

    CombAdder           adder      (in1, in2, adderOut, adderOverflowFlag); defparam adder.DATA_WIDTH=8;
    CombSubtractor      subtractor (in1, in2, subtractorOut, subtractorOverflowFlag); defparam subtractor.DATA_WIDTH=8;

    And_4bit            andGate    (in1[3:0], in2[3:0], andOut);
    Or_4bit             orGate     (in1[3:0], in2[3:0], orOut);
    Xor_4bit            xorGate    (in1[3:0], in2[3:0], xorOut);
    Inv_4bit            notGate    (in1[3:0], notOut);

    always @(*) begin // mux for control signals - assumes they won't be sent together
        
        out = 0; // is this correct?
        overflow = 0; // is this correct
        
        if (ADD) begin
            out = adderOut;
            overflow = adderOverflowFlag;
        end
        
        else if (SUB) begin
            out = subtractorOut;
            overflow = subtractorOverflowFlag;
        end
        
        // Logic
        else if (AND) begin
            out =  andOut;
            overflow = 0; 
        end

        else if (OR) begin
            out =  orOut;
            overflow = 0;
        end

        else if (XOR) begin
            out =  xorOut;
            overflow = 0;    
        end

        else if (INV) begin
            out =  notOut;
            overflow = 0;    
        end

        else if (CLR) begin
            out =  0;
            overflow = 0;    
        end
            
     end
     
endmodule


module FullAdder (
    input wire in1,
    input wire in2,
    input wire carryIn,
    output  sum,
    output  carryOut
);
    assign {carryOut,sum} = in1 + in2; // behavioural description

endmodule

// paramatreised size for input/output

module CombAdder (  // Conbinational, Behavioural Description
    input wire  [DATA_WIDTH - 1:0]  in1,
    input wire  [DATA_WIDTH - 1:0]  in2,
    output reg  [DATA_WIDTH - 1:0]  out,
    output reg                      overflow  
);
    parameter DATA_WIDTH  = 4; //4-bit by default;

    always @(*) begin
        {overflow, out} = in1 + in2;
    end

endmodule

module CombSubtractor (  // Combinational - Behavioural Description
    input wire  [DATA_WIDTH - 1:0]  in1,
    input wire  [DATA_WIDTH - 1:0]  in2,
    output reg  [DATA_WIDTH - 1:0]  out,
    output reg                      overflow  
);
    parameter DATA_WIDTH  = 4; //4-bit by default;

    always @(*) begin
        {overflow, out} = in1 - in2;
    end

endmodule



// Logic Unit Components

/*            Logic Unit
        /      |        |     \  
      AND      OR       XOR    INV
*/


//4-bit AND - combinational
module And_4bit(
    input wire [3:0] in1,
    input wire [3:0] in2,
    output wire [3:0] out
);

    assign out = in1 & in2;

endmodule 

// 4-bit OR - combinational
module Or_4bit(
    input wire [3:0] in1,
    input wire [3:0] in2,
    output wire [3:0] out
);

    assign out = in1 | in2;

endmodule

//4 -bit XOR - combinational 
module Xor_4bit (
    input wire [3:0] in1, in2,
    output wire [3:0] out
);

    assign out = in1 ^ in2;

endmodule 

//4 -bit XOR - combinational 
module  Inv_4bit (
    input wire [3:0] in1, 
    output wire [3:0] out
);

    assign out = ~in1;

endmodule 

