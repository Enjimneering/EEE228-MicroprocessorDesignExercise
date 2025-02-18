`include "ALU.v"
`include "Control.v"

module AeolusCPUTop(
    input wire       boardCLK,
    input wire       reset,
    input wire [7:0] switchValues,
    input  wire[3:0] data,
    output reg [3:0] out
);
    // 100MHZ -> xMHz CLK
    wire sysCLK;

    clkDiv clkdiv(  
        .CLKin(boardCLK),
        .CLKout(sysCLK)
    );

    // input registers

    wire [3:0] Ain;
    wire [3:0] Aout;
    wire       LDA;

    EnableDFF_4bit RegA (sysCLK, LDA, Ain, Aout);


    wire [3:0] Bin;
    wire [3:0] Bout;
    wire       LDB;

    EnableDFF_4bit RegB (sysCLK, LDB, Bin, Bout);

    // MUX FOR ALU Input

    ArithmeticUnit AU(
        .clk(sysCLK),
        .reset(reset),
        .add(),
        .sub(),
        .lshift(),
        .rshift(),
        .in1(),
        .in2(), 
        .out(ACCin),
        .overflow()
    );

    wire [3:0] ACCin;
    wire [3:0] ACCout;
    wire       CLR;
    wire       EnableACC;

    ResetEnableDFF_4bit ACC (sysCLK, CLR, EnableACC, ACCin, ACCout);
    
    wire [3:0] Oin;
    wire [3:0] Oout;
    wire EnableO;

    EnableDFF_4bit RegO (sysCLK, EnableO, Oin, Oout);

endmodule
