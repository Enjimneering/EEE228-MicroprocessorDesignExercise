module CPUsocket (
    input wire        Clkpin,        // Pin E3
    input wire [15:0] Switches,
    output reg [15:0] LEDs,
    output reg [6:0]  SevenSegmentChar,
    output reg [3:0]  DigitSelect
);
    wire SEGclk;
    wire reset = Switches[15];  // Use switch 15 as reset

    wire [15:0] segOutput;

  // 16-bit output from CPU to be displayed on 7-segment
    AeolusCPUTop cpu (Clkpin, Switches[15], Switches[7:0], segOutput);

    // Clock divider for 7-segment display multiplexing
    clkDiv segClkDiv (Clkpin, SEGclk);
    defparam segClkDiv.COUNTER_SIZE   =  64;
    defparam segClkDiv.COUNTER_TARGET =  32;

   
    wire [6:0] CPU_OUT_HI, CPU_OUT_LO;
    HexDigitDecoder_SEG7 cpu_out_hi (segOutput[11:8], CPU_OUT_HI); // High nibble
    HexDigitDecoder_SEG7 cpu_out_lo (segOutput[7:4],  CPU_OUT_LO); // Low nibble


    wire [6:0] OPCODE_DIGIT_1, OPCODE_DIGIT_2, OPCODE_DIGIT_3, OPCODE_DIGIT_4;
    OpcodeDisplay_SEG7 opcode_display (
        .opcode(segOutput[15:12]),  // Opcode is upper 4 bits
        .digit1(OPCODE_DIGIT_1),
        .digit2(OPCODE_DIGIT_2),
        .digit3(OPCODE_DIGIT_3),
        .digit4(OPCODE_DIGIT_4)
    );

    // Digit selection logic
    always @(posedge SEGclk ) begin
        if (reset) DigitSelect <= 0;
        else DigitSelect <= DigitSelect + 1;
    end 
    
    // Multiplexed 7-segment display output
    always @(*) begin
        case (DigitSelect)
            0: SevenSegmentChar = OPCODE_DIGIT_1;  // First digit of opcode
            1: SevenSegmentChar = OPCODE_DIGIT_2;  // Second digit of opcode
            2: SevenSegmentChar = OPCODE_DIGIT_3;  // Third digit of opcode
            3: SevenSegmentChar = OPCODE_DIGIT_4;  // Fourth digit of opcode
            4: SevenSegmentChar = CPU_OUT_HI;      // High nibble of CPU output
            5: SevenSegmentChar = CPU_OUT_LO;      // Low nibble of CPU output
            default: SevenSegmentChar = `CHAR_SPACE; // Blank display
        endcase
    end

    // Connect LEDs to the full 16-bit segOutput
    always @(*) begin
        LEDs = segOutput[15:0];
    end

endmodule