`include "src/ALU.v"
`include "src/Control.v"
`include "src/ROM.v"

//  Multi-cycle implimentation

//  Done: make everything single cycle 


//  K 
//  todo: comment and document the design so far.
//  todo: Test: Shift, Load Shift Reg 

// J
//  todo: impliment the example ROM.
//  todo: Test: conditional instructions

// BOTH .. later ...
//  todo: optimise the design for area (ALU reduction / Get rid of the increment adder).

//  Extensions:
//  todo: develop an extended instruction set using multi cycle
//  todo: impliment NOP 
//  todo: develop a pipelined desgin with extended IS


module AeolusCPUTop (

    input wire       boardCLK,
    input wire       reset,
    input wire [7:0] switches,
    output reg [7:0] cpuOut
);

    wire clk;

    // 100MHZ -> x MHz CLK
    clkDiv clkdiv(  .CLKin(boardCLK), .CLKout(clk) );

    // Program Counter 
    wire [7:0] PCin;
    wire [7:0] INCout;
    wire [7:0] PCout;
    wire PCoverflow;
    reg  incrementValue;
    
    ResetEnableDFF PC (clk, reset, 1'b1 , PCin, PCout);
    defparam PC.DATA_WIDTH = 8;
   
    // Incrementer
    CombAdder inc (PCout, 8'b0000_0001, PCin , PCoverflow); 
    defparam inc.DATA_WIDTH = 8;

    // Program ROM
    wire [3:0] opcode;
    ProgramROMtest rom ( .addressIn(PCout), .dataOut(opcode));
    defparam rom.ADDR_WIDTH = 8;
    
    // instruction decoder
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

    wire [3:0] Aout, Bout;
    wire [7:0] Oout;

    RegisterFile rf (
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

    // ALU Instructions Control Signals

    wire LSR, _LDSA, _LDSB;         // Load shift register
    assign _LSR = _LDSA || _LDSB;

    wire _LSR, _LSH, _RSH;          // Shift
    wire _ADD, _SUB;                // Arithmetic
    wire _AND, _OR, _XOR, _INV;     // Logical Instruction

    // ALU control flags
    reg _ADDin;
    reg _shiftFlag;
    wire SF;

    // ALU inputs
    reg [3:0] in1;
    reg [3:0] in2;

    // MUX for ALU inputs , depends on control signals .
    // e.g (SNZA, SNZB, LDSA and LDSB require different inputs.

    always @(*) begin 
        
        _shiftFlag = SF;

        // Instructions involving addition (SNZ and ADD)
        if ((_SNZA | _SNZS) && _shiftFlag == 1) begin
            _ADDin = 1;
        end else begin
            _ADDin = _ADD;
        end
        if ((_SNZA == 1  && _shiftFlag == 1) || _LDSA)  begin // load A and Accumulator in.
            in1 = Aout;
            in2 = ACCout;
        end else if (_LDSB) begin // load B into shift reg
            in1 = Bout;
        end else if ((_SNZS == 1 && _shiftFlag == 1)) begin
            in1 = alu.shiftOut;
            in2 = ACCout;
        end else begin // non conditional instructinos
            in1 = Aout;
            in2 = Bout;
        end

    end 

    wire       OF; 
    wire       _CLR;
    wire [7:0] aluOut;

    // alu
    ArithmeticLogicUnit alu( 
        .clk(clk),
        .reset(reset),
        .ADD(_ADDin),
        .SUB(_SUB),
        .LSR(_LSR),
        .LSH(_LSH),
        .RSH(_RSH),
        .AND(_AND),
        .OR (_OR),
        .XOR(_XOR),
        .INV(_INV),
        .CLR(_CLR),
        .in1(in1),
        .in2(in2), 
        .out(aluOut),
        .overflow(OF),
        .shiftFlag(SF)
    );

    // accumulator
    wire [7:0] ACCout;
    wire enableALU = _CLR || _ADD ||_SUB ||_LSH||_RSH;
    ResetEnableDFF ACC (clk, _CLR || reset, enableALU ,aluOut, ACCout); defparam ACC.DATA_WIDTH = 8;

    // output of the whole CPU
    always @(*) begin
        cpuOut = Oout;
    end

endmodule
