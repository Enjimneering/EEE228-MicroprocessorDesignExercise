// Arithmetic Logic Unit

// Arithmetic Unit Components
/*
         AU
             \
             4-Bit Adder
                \     
               full adder 


*/

module FullAdder(
    input wire clk,
    input wire reset, 
    input wire in1,
    input wire in2,
    input wire carryIn,
    output reg sum,
    output reg carryOut
);

    always @(posedge clk) begin
        if (~reset) begin
            {carryOut,sum} <= in1 + in2; // behavioural description
        end
    end

    /* Gate level Description - truth table

        a b c  c  s
        0 0 0  o  o
        0 0 1  0  1
        0 1 0  0  1
        0 1 1  1  0
        1 0 0  0  1
        1 0 1  1  0
        1 1 0  1  0
        1 1 1  1  1
    
        sum   =  ~a~bc   + ~ab~c + a~b~c + abc
              =  a~b~c   + abc   + ~a~bc + ~ab~c 
              =  a(~b~c) + a(bc) + ~a~bc + ~ab~c
              =  a(~b~c  + bc)    + ~a~bc + ~ab~c
              =  a(b xor c)      + ~a~bc + ~ab~c
              =  a(b xor c)              + ~a~bc + ~ab~c
              =  a(b xor c)                + ~a(bc + b~c)
              =  a(b xor c)                + ~ab(c + ~c)
              =  a(b xor c)                + ~ab(1)
     
        
        carry =  a and (b xor c) or ab



    */




endmodule