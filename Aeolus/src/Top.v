`include "src/ALU.v"
`include "src/Control.v"
`include "src/ROM.v"

//  Multi-cycle implimentation

//  todo: comment and document the design so far.
//  todo: add Logic for variable clock cycle instructions (instead of just delaying the signal)
//  todo: Test: Shift, Load Shift Reg , Conditional Instructions
//  todo: impliment the example ROM.
//  todo: optimise the desgin for area (ALU reduction / Get rid of the increment adder).

//  extensions:
//  todo: develop a single-cycle version
//  todo: impliment NOP using a flag.
//  todo: develop a pipelined desgin
//  todo: look into 5-bit opcode decoder for expansion


module AeolusCPUTop(

    input wire       boardCLK,
    input wire       reset,
    input wire [7:0] switches,
    output reg [3:0] cpuOut
);
    wire clk;

    // 100MHZ -> x MHz CLK
    clkDiv clkdiv(  
        .CLKin(boardCLK),
        .CLKout(clk)
    );

    // Program Counter 
    wire [3:0] PCin;
    wire [3:0] PCout;
    wire PCoverflow;
    reg [3:0] incrementValue;
    
    ResetEnableDFF_4bit PC (clk, reset, 1'b1, PCin, PCout);
    
    CombAdder_4bit inc (PCout, incrementValue , PCin, PCoverflow ); 
    
    // todo - variable cycle lengths.
    // make the PC stay on LD0 for 2 cycles

    reg writebackComplete = 1;

    always @(*) begin
        if (writebackComplete) begin
             incrementValue = 1;
        end else begin 
            incrementValue = 0;
        end
    end

    wire [3:0] opcode;

    ProgramROM rom (clk, PCout, opcode);

    // Instruction decoder
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

    // A register

    wire       _LDA;
    wire [3:0] Aout;

    EnableDFF_4bit RegA (clk, _LDA, switches[7:4], Aout);

    // B register

    wire       _LDB;
    wire [3:0] Bout;

    EnableDFF_4bit RegB (clk, _LDB, switches[3:0], Bout);

    // ALU Instructions
    wire _LDSA, _LDSB;

    wire _ADD, _SUB, _LSR, _LSH, _RSH,
         _AND, _OR, _XOR, _INV;

    // ALU control
    reg _ADDin;
    reg _shiftFlag;
    wire SF;

    // ALU inputs
    reg [3:0] in1;
    reg [3:0] in2;

    always @(*) begin // MUX for ALU inputs , different for some  operations e.g (SNZA, SNZB, LDSA and LDSB)
        
        _shiftFlag = SF;

        if (_SNZA | _SNZS ) begin
            _ADDin = 1;
        end else  begin
            _ADDin = _ADD;
        end

        if (_SNZA == 1  && _shiftFlag == 1 || _LDSA)  begin
            in1 = Aout;
            in2 = 0;
        end else if (_LDSB) begin
            in1 = Bout;
            in2 = 0;
        end else if ((_SNZS == 1 && _shiftFlag == 1)) begin
            in1 = alu.shiftOut ;
            in2 = 0;
        end else begin // non conditional instructinos
            in1 = Aout;
            in2 = Bout;
        end

    end 

    wire [3:0] aluOut;
    wire       OF;

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
        .in1(in1),
        .in2(in2), 
        .out(aluOut),
        .overflow(OF),
        .shiftFlag(SF)
    );

    wire       _CLR;
    wire [3:0] ACCout;

    // accumulator
    ResetDFF_4bit ACC (clk, _CLR, aluOut, ACCout);
    
    wire      _LDO;
    wire      _LDO2;
    wire [3:0] Oout;
    
    // buffer and output register
    DFF LDOBuff (clk, _LDO,_LDO2);
    EnableDFF_4bit RegO (clk, _LDO2, ACCout, Oout);


    always @(*) begin
        cpuOut = Oout;
    end

endmodule
