`include "ALU.v"
`include "Control.v"
`include "ROM.v"

//  Done:
//        impliment the example ROM.
//        test example program

//  Both:
//  todo: comment and document the design so far.
//  todo: write test benches and sign off on:
    //  conditional instructions
    //  shift flag/ L/RSH Results
    //  all register types

//  Extension Tasks - develop an extended instruction set for graphics  (w/ NOP)
//  Extension Tasks - develop a multi-cycle version (logic reduction)
//  Extension Tasks - develop a pipelined version

module AeolusCPUTop (
    input wire       boardCLK,
    input wire       reset,
    input wire [7:0] switches,
    output reg [7:0] cpuOut
);

    parameter ROM_ADDRESS_WIDTH = 8;
    parameter INPUT_DATA_WIDTH = 4;
    parameter OUTPUT_DATA_WIDTH = 8;

    // Clock divider 
    clkDiv clkdiv(  .CLKin(boardCLK), .CLKout(clk) );

    // Program Counter 
    wire [ROM_ADDRESS_WIDTH-1:0] PCin;
    wire [ROM_ADDRESS_WIDTH-1:0] PCout;

    ResetEnableDFF PC (clk, reset, 1'b1 , PCin, PCout);
    defparam PC.DATA_WIDTH = ROM_ADDRESS_WIDTH;
   
    // Incrementer
    CombAdder inc (PCout, 8'b0000_0001, PCin , PCoverflow); 
    defparam inc.DATA_WIDTH = ROM_ADDRESS_WIDTH;

    // Program ROM
    wire [3:0] opcode;
    
    ProgramROMtest rom ( .addressIn(PCout), .dataOut(opcode));
    defparam rom.ADDR_WIDTH = ROM_ADDRESS_WIDTH;
    
    // Instruction Decoder
    // opcode in -> control signal out
    
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

    // Regsiter File 
    // contains A reg and B reg and O reg

    wire [INPUT_DATA_WIDTH-1:0]  Aout, Bout;
    wire [OUTPUT_DATA_WIDTH-1:0] Oout;
    wire  [OUTPUT_DATA_WIDTH-1:0] Oin;

    RegisterFile registerFile (
        .clk(clk),
        .reset(reset),
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

    //shift Instructions/ Control Singals
    wire _LDSA, _LDSB;              // Load shift register
   
    
    //  Shifter
    wire _LSH, _RSH;                // Shift control sig
    wire  [INPUT_DATA_WIDTH-1:0]  shiftIn;
    wire [OUTPUT_DATA_WIDTH-1:0] shiftOut;
    wire SF;

    // MUX for Shift Register Inputs 
    SR_MUX srmux (_LDSA, _LDSB, Aout, Bout, shiftIn, _LSR);

    ShiftRegister sr (clk, reset, shiftIn, _LSR, {_LSH,_RSH}, shiftOut, SF);

    // ALU addition control flags 
    wire _ADDin;

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

    // ACC inputs
    wire        OF; 
    wire       _CLR;
    wire [OUTPUT_DATA_WIDTH-1:0] aluOut;

    // Arithmetic Logic Unit (combintorial)
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

    // Accumulator (ACC)
    wire [OUTPUT_DATA_WIDTH-1:0] ACCout;
    
    ENABLE_ACC_MUX accmux ( _AND, _OR, _XOR, _INV, _ADDin, _SUB, _CLR, enableACC);

    ResetEnableDFF ACC (clk, _CLR || reset, enableACC , aluOut, ACCout); 
    defparam ACC.DATA_WIDTH = OUTPUT_DATA_WIDTH;

    // CPU Output
    always @(*) begin
        cpuOut = Oout;
    end

    initial begin
        $dumpvars(0,AeolusCPUTop);
        $dumpfile("dump.vcd");
    end
endmodule

