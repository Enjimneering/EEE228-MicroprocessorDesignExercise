`include "src/ALU.v"
`include "src/Control.v"
`include "src/ROM.v"

//  Done:
//        impliment the example ROM.
//        test example program

//  Both:
//  todo: comment and document the design so far.
//  todo: wire test benches and sign off on:
//  conditional instructions
//  shift flag/ L/RSH Results
//  todo: 


//  Extension Tasks - develop an extended instruction set for graphics  (w/ NOP)
//  Extension Tasks - develop a multi-cycle version (logic reduction)
//  Extension Tasks - develop a pipelined version



module AeolusCPUTop (
    input wire       clk,
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
    wire [ROM_ADDRESS_WIDTH-1:0] INCout;
    wire [ROM_ADDRESS_WIDTH-1:0] PCout;
    wire PCoverflow;
    reg  incrementValue;
    
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
    reg  [INPUT_DATA_WIDTH-1:0]  Ain, Bin;
    wire [OUTPUT_DATA_WIDTH-1:0] Oout;
    reg  [OUTPUT_DATA_WIDTH-1:0] Oin;

    // Synch reset for register file output 
    always @(posedge clk) begin
        if (~reset) begin
            Oin = ACCout;
        end else begin
            Oin = 0;
        end

    end

    RegisterFile rf (
        .clk(clk),
        .reset(reset),
        .AIn(switches[7:4]),
        .BIn(switches[3:0]),
        .OIn(Oin),
        .LDA(_LDA),
        .LDB(_LDB),
        .LDO(_LDO),
        .Aout(Aout),
        .Bout(Bout),
        .Oout(Oout)
    );

    //shift Instructions/ Control Singals
    wire LSR, _LDSA, _LDSB;         // Load shift register
    assign _LSR = _LDSA || _LDSB;
    wire _LSR, _LSH, _RSH;          // Shift

    // MUX for Shift Register Inputs 
    always @(*) begin
        if (_LDSA) begin
           shiftIn = Aout;
        end else if (_LDSB) begin
           shiftIn = Bout;
        end else begin
           shiftIn = 0 ;
        end
    end

    //  Shifter
    reg  [INPUT_DATA_WIDTH-1:0]  shiftIn;
    wire [OUTPUT_DATA_WIDTH-1:0] shiftOut;
    wire SF;

    ShiftRegister sr (clk, reset, shiftIn, _LSR, {_LSH,_RSH}, shiftOut, SF);

    // ALU addition control flags 
    reg _ADDin;

    // MUX for addition control flag
    always @(*) begin 

        if ((_SNZA | _SNZS)) begin
            if (SF == 1)
                _ADDin = 1;
            end else begin
                _ADDin = _ADD;
            end
    end 

    wire _ADD, _SUB;                // Arithmetic
    wire _AND, _OR, _XOR, _INV;     // Logical Instruction

    // ALU inputs
    reg [OUTPUT_DATA_WIDTH-1:0] in1;
    reg [OUTPUT_DATA_WIDTH-1:0] in2;

    // MUX for ALU inputs , depends on control signals .
    // e.g (SNZA, SNZB, LDSA and LDSB require different inputs.
    always @(*) begin 

        // set ALU inputs
        if ((_SNZA == 1  && SF == 1) || _LDSA)  begin // load A and Accumulator in.
            in1 = Aout;
            in2 = ACCout;
       
        end else if (_LDSB) begin // load B into shift reg
            in1 = Bout;

        end else if ((_SNZS == 1 && SF == 1)) begin // add ACC and Shifter
            in1 = shiftOut;
            in2 = ACCout;

        end else begin // non conditional instructinos
            in1 = Aout;
            in2 = Bout;
        end

    end 

    // ACC inputs
    wire        OF; 
    wire       _CLR;
    wire [OUTPUT_DATA_WIDTH-1:0] aluOut;

    // Arithmetic Logic Unit (combintorial)
    ArithmeticLogicUnit alu( 
        .clk(clk),
        .reset(reset),
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
        .overflow(OF),
        .shiftFlag(SF)
    );

    // Accumulator (ACC)
    wire [OUTPUT_DATA_WIDTH-1:0] ACCout;
    wire logicSignal = _AND ||  _OR || _XOR || _INV;
    wire arithmeticSignal = _ADDin || _SUB;
    wire enableALU = _CLR || arithmeticSignal || logicSignal;  // alu needs to be enabled usign the relevant instruction

    ResetEnableDFF ACC (clk, _CLR || reset, enableALU , aluOut, ACCout); 
    defparam ACC.DATA_WIDTH = OUTPUT_DATA_WIDTH;

    // CPU Output
    always @(*) begin
        cpuOut = Oout;
    end

endmodule
