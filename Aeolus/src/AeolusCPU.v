`timescale 1us/1ns 

`include "Control.v"
`include "ALU.v"
`include "Registers.v"
`include "ROM.v"

// Development Tasks
//  todo: Paramaterise all bus lenghts inside ALU
//  todo: comment and document the design so far.
//  todo: write testbenches and sign off on:
    //  Registers - DFF, ResetDFF, ResetEnableDFF
    //  Shifter - Flag, LSH and RSH Results
    //  Conditional instructions - SNZS, SNZA
//  todo: develop FPGA TestSocket Modules (7-Seg)
//  todo: reduce logic - ALU minimisation/counter minimisation

//  Extension Tasks 
    //  - develop a pipelined version of the CPU with extended instruction set (w/ NOP) for graphicsÃŸ
    //  - Impliment Branches
    //  - Impliment VGA
    //  - Write Simple Graphics Demo

module AeolusCPUTop (
    input wire boardCLK,
    input wire reset,
    input wire [INPUT_DATA_WIDTH*2-1:0] switches,
    output reg [OUTPUT_DATA_WIDTH-1:0]  cpuOut
);

    parameter ROM_ADDRESS_WIDTH = 5;
    parameter INPUT_DATA_WIDTH = 4;
    parameter OUTPUT_DATA_WIDTH = 8;

    // Clock divider 
    // Optionally splits the board clocck into a lower frequency
    clkDiv clkdiv(  .CLKin(boardCLK), .CLKout(clk) );
    defparam clkdiv.COUNTER_TARGET = 24; // display speed

    wire [ROM_ADDRESS_WIDTH-1:0] PCin;   // Next address to be decoded
    wire [ROM_ADDRESS_WIDTH-1:0] PCout;  // Current address being decoded
    
    // Program Counter
    // Outputs the address of the instruction being executed and increments every clk cycle
    // ResetEnableDFF PC (clk, reset, 1'b1 , PCin, PCout);
    // defparam PC.DATA_WIDTH = ROM_ADDRESS_WIDTH;
   
    // Counter PC
    Counter programCounter (clk, reset, 1'b1, PCout);
    defparam programCounter.DATA_WIDTH = ROM_ADDRESS_WIDTH;

    // // Incrementer
    // // Incrememnts the program counter
    // combAdder inc (PCout, 8'b0000_0001, PCin , PCoverflow); 
    // defparam inc.DATA_WIDTH = ROM_ADDRESS_WIDTH;

    // Program ROM
    // Stores the program  
    ProgramROMtest rom ( .addressIn(PCout), .dataOut(opcode));
    defparam rom.ADDR_WIDTH = ROM_ADDRESS_WIDTH;
    wire [3:0] opcode; // Current opcode being executed - output from instruction ROM 
    
    // Instruction Decoder
    // Decodes the opcode from the program rom and outputs the appropriate control signalsÃŸ
    InstructionDecoder decoder (
        .instructionIn(opcode),
        .LDA  (_LDA),
        .LDB  (_LDB),
        .LDO  (_LDO),
        .LDSA (_LDSA),
        .LDSB (_LDSB),
        .LSH  (_LSH),
        .RSH  (_RSH),
        .CLR  (_CLR),
        .SNZA (_SNZA),
        .SNZS (_SNZS),
        .ADD  (_ADD),
        .SUB  (_SUB),
        .AND  (_AND),
        .OR   (_OR),
        .XOR  (_XOR),
        .INV  (_INV)
    );

    wire  [INPUT_DATA_WIDTH-1:0]  Aout, Bout;
    wire  [OUTPUT_DATA_WIDTH-1:0] Oout;
    wire  [OUTPUT_DATA_WIDTH-1:0] Oin;

    // Regsiter File 
    // Contains A reg and B reg and O reg
    RegisterFile registerFile (
        .clk(clk),
        .reset(reset),
        // split switch input into A and B input
        .AIn(switches[7:4]), 
        .BIn(switches[3:0]),
        .OIn(ACCout),
        .LDA(_LDA),
        .LDB(_LDB),
        .LDO(_LDO),
        .Aout(Aout),
        .Bout(Bout),
        .Oout(Oout)
    );

    //Shift Instructions/ Control Singals
    wire _LDSA, _LDSB;                      // Load shift register
    wire _LSH, _RSH;                        // Shift Control signals
    wire [INPUT_DATA_WIDTH-1:0]  shiftIn;
    wire [OUTPUT_DATA_WIDTH-1:0] shiftOut;
    wire SF;                                // Shift Flag

    // MUX for Shift Register Inputs 
    SR_MUX srmux (_LDSA, _LDSB, Aout, Bout, shiftIn, _LSR);

    // Shifter
    // Register for implimenting shift instructions and storing the results
    ShiftRegister sr (clk, reset, shiftIn, _LSR, {_LSH,_RSH}, shiftOut, SF);

    wire _ADDin; // ALU addition control flag

    // MUX for addition control flag

    ADD_MUX addmux (_ADD, _SNZA,_SNZS, SF, _ADDin);

    wire _ADD, _SUB;                // Arithmetic
    wire _AND, _OR, _XOR, _INV;     // Logical Instruction

    // ALU inputs
    wire [OUTPUT_DATA_WIDTH-1:0] in1;
    wire [OUTPUT_DATA_WIDTH-1:0] in2;

    // MUX for ALU inputs , depends on control signals .
    // e.g (SNZA, SNZB, LDSA and LDSB require different inputs.

    ALU_MUX alumux (_SNZA, _SNZS, SF ,shiftOut, ACCout, Aout, Bout, in1,in2);

    // Arithmetic Logic Unit (combinatorial)
    ArithmeticLogicUnit alu( 
        .ADD(_ADDin),
        .SUB(_SUB),
        .AND(_AND),
        .OR (_OR),
        .XOR(_XOR),
        .INV(_INV),
        .CLR(_CLR),
        .in1(in1),
        .in2(in2), 
        .out(aluOut),
        .overflow(OF)
    );
    
    // Logic to enable the Accumulator 
    ENABLE_ACC_MUX accmux ( _AND, _OR, _XOR, _INV, _ADDin, _SUB, _CLR, enableACC);
    wire [OUTPUT_DATA_WIDTH-1:0] ACCout;

    // Accumulator Input 
    wire        OF; 
    wire       _CLR;
    wire [OUTPUT_DATA_WIDTH-1:0] aluOut;

    // Accumulator (ACC)
    // Stores the results of Arithmetic or Logical operations
    ResetEnableDFF ACC (clk, _CLR || reset, enableACC , aluOut, ACCout); 
    defparam ACC.DATA_WIDTH = OUTPUT_DATA_WIDTH;

    // CPU Output
    always @(*) begin
        cpuOut = Oout;
    end

    initial begin // dump output
        $dumpfile("dump.vcd");
        $dumpvars(0,AeolusCPUTop);
    end
endmodule

