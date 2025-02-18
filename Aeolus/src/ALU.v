// Arithmetic Logic Unit

`include "src/Registers.v"

// Arithmetic Unit Components
/*
         Arithmetic Unit
              \
            8-bit RC Adder
                 \
                4-Bit Adder
                    \     
                Full adder 
*/

module ArithmeticUnit (
    input wire       clk,
    input wire       reset,
    input            add,
    input            sub,
    input            lshift,
    input            rshift,
    input wire [3:0] in1,
    input wire [3:0] in2, 
    output reg [3:0] out,
    output reg       overflow

);

    wire [3:0] shiftOut, adderOut, subtractorOut;
    wire shiftFlag, adderOverflowFlag, subtractorOverflowFlag;

    ShiftRegister       sr         (clk, in1, enable, {lshift,rshift}, shiftOut, shiftFlag);
    CombAdder_4bit      adder      (in1, in2, adderOut, adderOverflowFlag);
    CombSubtractor_4bit subtractor (in1, in2, subtractorOut, subtractorOverflowFlag);

    always @(posedge clk) begin // assumes control signals can't be sent together
        
        if (add) begin
            out <= adderOut;
            overflow <= adderOverflowFlag;
        end

        if (sub) begin
            out <= subtractorOut;
            overflow <= subtractorOverflowFlag;
        end

        if (lshift || rshift)
            out <= shiftOut;
            overflow <= shiftFlag;
    end

endmodule


module ShiftRegister (  // sequential shift register (D type FF with Enable)
        input wire       clk,
        input wire [3:0] in,
        input wire       loadEnable,
        input      [1:0] shiftstate,  //reg
        output reg [3:0] out,
        output reg       flag
);
   
    wire [3:0] dataReg;

    EnableDFF_4bit inShift (clk, loadEnable, in, dataReg);

        always @(posedge clk ) begin   
            if (shiftstate == 2'b10) begin     // LSH
                {flag,out} = dataReg << 1;

            end if (shiftstate == 2'b01) begin // RSH
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
module SyncRippleCarryAdder_4bit ( // synchronous design, hierarchal desgin
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
        {overflow, out} <= in1 + in2;
    end

endmodule

//  4-bit Subtractor
module CombSubtractor_4bit (  // Combinational - Behavioural Description
    input wire  [3:0]  in1,
    input wire  [3:0]  in2,
    output reg  [3:0]  out,
    output reg         overflow  
);

    always @(*) begin
        {overflow, out} <= in1 - in2;
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
            {overflow, out} <= in1 + in2;
        end begin
            out <= 0;
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
            {overflow, out} <= in1 - in2;
        end begin
            out <= 0;
        end
    end 

endmodule

//4-bit AND  
module and_gate(
         input wire [3:0] in1,
         input wire [3:0] in2,
         output wire [3:0] out
);

assign out = in1 & in2;
         
endmodule 

// 4-bit OR

module or_gate(
         input wire [3:0] in1,
         input wire [3:0] in2,
         output wire [3:0] out
);

assign out = in1 | in2;
endmodule

//4-bit XOR
module xor_gate (
         input wire [3:0] in1, in2,
         output wire [3:0] out
);

assign out = in1 ^ in2;

endmodule 
