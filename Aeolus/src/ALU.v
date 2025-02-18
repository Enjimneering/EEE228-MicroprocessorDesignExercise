// Arithmetic Logic Unit

// Arithmetic Unit Components
/*
         AU
              \
            8-bit RC Adder
                 \
                4-Bit Adder
                    \     
                Full adder 
*/

module FullAdder(
    input wire in1,
    input wire in2,
    input wire carryIn,
    output  sum,
    output  carryOut
);

    assign {carryOut,sum} = in1 + in2; // behavioural description

    /* Gate level Description - truth table (not conventional order for variables)
        a b c  c  s
        0 0 0  0  0
        0 0 1  0  1
        0 1 0  0  1
        0 1 1  1  0
        1 0 0  0  1
        1 0 1  1  0
        1 1 0  1  0
        1 1 1  1  1
    
        sum   =  ~a~bc  + ~ab~c   + a~b~c   + abc
        
        carry = ~abc + a~bc + ab~c + abc
              = bc(a + ~a) + a~bc + ab~c
              = bc + a(~bc + b~c)
              = bc + a(b ^ c)
    */
endmodule

// ripple carry adder 4-bits

module RippleCarryAdder_4bit ( //(synchronous design, hierarchal desgin)
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

module Adder_8bit (    // Behavioural Descriptiion
    input wire         clk,
    input wire         reset,
    input wire  [7:0]  in1,
    input wire  [7:0]  in2,
    output reg  [7:0]  out,
    output reg         overflow
);

    always @(posedge clk ) begin
        if (~reset) begin
            {overflow, out} <= in1 + in2;
        end begin
            out <= 0;
        end
    end
    
endmodule

module Subtractor_8bit (  // Behavioural Descriptiion
    input wire         clk,
    input wire         reset,
    input wire  [7:0]  in1,
    input wire  [7:0]  in2,
    output reg  [7:0]  out,
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


