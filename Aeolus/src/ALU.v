// Arithmetic Logic Unit

`include "src/Registers.v"

// Arithmetic Unit Components
/*
               Arithmetic Unit
            /         |         \
        4bitAdder 4bitSubtractor 4bitShifter
        
*/

module ArithmeticLogicUnit (
    input wire       clk,
    input wire       reset,
    input            ADD,
    input            SUB,
    input            LSR,
    input            LSH,
    input            RSH,
    input wire       AND,
    input wire       OR,
    input wire       XOR,
    input wire       INV,
    input wire       CLR,
    input wire [3:0] in1,
    input wire [3:0] in2, 
    output reg [3:0] out,
    output reg       overflow,
    output wire      shiftFlag

);

    wire [3:0] shiftOut, adderOut, subtractorOut;
    wire adderOverflowFlag, subtractorOverflowFlag;
    wire [3:0] andOut;
    wire [3:0] orOut;
    wire [3:0] xorOut;
    wire [3:0] notOut;

    ShiftRegister       sr         (clk, in1, LSR, {LSH,RSH}, shiftOut, shiftFlag);
    CombAdder_4bit      adder      (in1, in2, adderOut, adderOverflowFlag);
    CombSubtractor_4bit subtractor (in1, in2, subtractorOut, subtractorOverflowFlag);
    And_4bit            andGate    (in1, in2, andOut);
    Or_4bit             orGate     (in1, in2, orOut);
    Xor_4bit            xorGate    (in1, in2, xorOut);
    Inv_4bit            notGate    (in1, notOut);


    always @(*) begin // mux for control signals - assumes they won't be sent together
    
        // Arithmetic
        if (ADD) begin
            out = adderOut;
            overflow = adderOverflowFlag;
        end

        if (SUB) begin
            out = subtractorOut;
            overflow = subtractorOverflowFlag;
        end

        if (LSH) begin
            out = shiftOut;
        end

        if (RSH) begin
            out = shiftOut;
        end

        // Logic
        if (AND) begin
            out =  andOut;
            overflow = 0; 
        end

        if (OR) begin
            out =  orOut;
            overflow = 0;
        end

        if (XOR) begin
            out =  xorOut;
            overflow = 0;    
        end

        if (INV) begin
            out =  notOut;
            overflow = 0;    
        end

         if (CLR) begin
            out =  0;
            overflow = 0;    
        end
        
    end

endmodule


module ShiftRegister (  // sequential shift register (D type FF with Enable)
    input wire       clk,
    input wire [3:0] in,
    input wire       loadEnable,
    input      [1:0] shiftState,  //reg
    output reg [3:0] out,
    output reg       flag
);
   
    wire [3:0] dataReg;

    EnableDFF_4bit inShift (clk, loadEnable, in, dataReg); // sequential load

        always @(*) begin    // combinatorial output 
            if (shiftState == 2'b10) begin     // LSH
                {flag,out} = dataReg << 1;

            end if (shiftState == 2'b01) begin // RSH
                {flag,out} = dataReg >> 1;
            end

        end

endmodule

module FullAdder(
    input wire in1,
    input wire in2,
    input wire carryIn,
    output  sum,
    output  carryOut
);
    assign {carryOut,sum} = in1 + in2; // behavioural description

endmodule

// ripple carry adder 4-bits - not verified
module SyncRippleCarryAdder_4bit (  // synchronous design, hierarchal desgin
    input wire         clk,
    input wire         reset,
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg         overflow
);
    wire carry1,carry2,carry3,carry4;
    reg c1, c2, c3;

    wire o0, o1, o2, o3;

    FullAdder f1 (in1[0], in2[0], 1'b0, o0, carry1);
    FullAdder f2 (in1[1], in2[1], c1,   o1, carry2);
    FullAdder f3 (in1[2], in2[2], c2,   o2, carry3);
    FullAdder f4 (in1[3], in2[3], c3,   o3, carry4);

    always @(posedge clk) begin
        if (~reset) begin
            c1 <= carry1;
            c2 <= carry2;
            c3 <= carry3;

            out[0] <= o0;
            out[1] <= o1;
            out[2] <= o2;
            out[3] <= o3;
            overflow <= carry4;
        
        end else begin
            c1 <= 0;
            c2 <= 0;
            c3 <= 0;

            out[0] <= 0;
            out[1] <= 0;
            out[2] <= 0;
            out[3] <= 0;
            overflow <= 0;
        end

    end

endmodule

// 4-bit adder
module CombAdder_4bit ( // Conbinational, Behavioural Description
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg         overflow  
);

    always @(*) begin
        {overflow, out} = in1 + in2;
    end

endmodule

//  4-bit Subtractor
module CombSubtractor_4bit (  // Combinational - Behavioural Description
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg        overflow  
);

    always @(*) begin
        {overflow, out} = in1 - in2;
    end

endmodule

// 4-bit Adder
module SyncAdder_4bit (  // Synchronous, Behavioural Descriptiion
    input wire         clk,
    input wire         reset,
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg         overflow  // what does this represent in a subtractionn?
);
    always @(posedge clk) begin
        if (~reset) begin
            {overflow, out} = in1 + in2;
        end begin
            out = 0;
        end
    end 

endmodule

//4-bit Subtractor
module SyncSubtractor_4bit (  // Synchronous, Behavioural Descriptiion
    input wire         clk,
    input wire         reset,
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg         overflow  // what does this represent in a subtractionn?
);

    always @(posedge clk ) begin
        if (~reset) begin
            {overflow, out} = in1 - in2;
        end begin
            out = 0;
        end
    end 

endmodule

// Logic Unit Components

/*         Logic Unit
        /      |       \
      AND      OR       XOR 
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

