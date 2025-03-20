// CPU socket

module CPUsocket (
    input wire        Clkpin,        // Pin E3
    input wire [8:0]  Switches,
    output reg [6:0]  SevenSegmentChar,
    output reg [7:0]  Anode
);
    wire SEGclk;
    wire reset;
    
    AeolusCPUTop cpu ( 
        Clkpin, 
        Switches[8],
        Switches[7:0],
        cpuOut
    );
    
     wire  [7:0]  cpuOut;

    clkDiv segClkDiv (Clkpin, SEGclk);
    defparam segClkDiv.COUNTER_TARGET = 16;
   
    HexDigitDecoder_SEG7 CPUoutHIdecoder (cpuOut[7:4], OUT_HI);
    HexDigitDecoder_SEG7 CPULoutLOdecoder (cpuOut[3:0], OUT_LO);
    HexDigitDecoder_SEG7 INPUT_A(Switches[7:4],IN_A);
    HexDigitDecoder_SEG7 INPUT_B(Switches[3:0],IN_B);

    reg [2:0] DigitSelect;
    
    always @(posedge SEGclk) begin
        if (reset) DigitSelect <= 0;
        else DigitSelect <= DigitSelect + 1;
    end 
    
    wire [6:0] OPCODE_DIGIT_1, OPCODE_DIGIT_2, OPCODE_DIGIT_3, OPCODE_DIGIT_4, OUT_HI, OUT_LO, IN_A, IN_B;
    
    OpcodeDisplay_SEG7 opcode_display (
        .opcode(cpu.opcode),  // Opcode is upper 4 bits
        .digit1(OPCODE_DIGIT_1),
        .digit2(OPCODE_DIGIT_2),
        .digit3(OPCODE_DIGIT_3),
        .digit4(OPCODE_DIGIT_4)
    );
    
    always @(*) begin
        case (DigitSelect)
            0: Anode = 8'b11111110;  // Rightmost digit (active low)
            1: Anode = 8'b11111101;
            2: Anode = 8'b11111011;
            3: Anode = 8'b11110111;
            4: Anode = 8'b11101111;
            5: Anode = 8'b11011111;
            6: Anode = 8'b10111111;
            7: Anode = 8'b01111111;  // Leftmost digit
        endcase
    end
   
    always @(*) begin
        case (DigitSelect)        // Todo: link this so that from Left to right it goes 
            0: SevenSegmentChar = OUT_LO;  // First digit of opcode
            1: SevenSegmentChar = OUT_HI;  // First digit of opcode
            2: SevenSegmentChar = IN_B  ;   //  B
            3: SevenSegmentChar = IN_A;  // A
            4: SevenSegmentChar = OPCODE_DIGIT_4;  // Fourth digit of opcode
            5: SevenSegmentChar = OPCODE_DIGIT_3;      // High nibble of CPU output
            6: SevenSegmentChar = OPCODE_DIGIT_2;      // Low nibble of CPU output
            7: SevenSegmentChar = OPCODE_DIGIT_1;      // Low
        endcase
    end

endmodule
