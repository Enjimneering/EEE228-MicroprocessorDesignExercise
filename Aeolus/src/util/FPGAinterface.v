// CPU socket
`include "src/Control.v"
`include "src/util/SevenSegment.v"

module CPUsocket (
    input wire        Clkpin,        // Pin E3
    input wire [15:0] Switches,
    output reg [15:0] LEDs,
    output reg [6:0]  SevenSegmentChar,
    output reg [3:0]  DigitSelect
);
   
    wire SEGclk;
    wire reset;

    clkDiv segClkDiv (Clkpin, SEGclk);
    defparam segClkDiv.COUNTER_SIZE   =  64;
    defparam segClkDiv.COUNTER_TARGET =  32;

    HexDigitDecoder_SEG7 CPU_OUT_LO ();
    HexDigitDecoder_SEG7 CPU_OUT_HI ();
    OpcodeDisplay_SEG7 OPCODE_OUT ();

    always @(posedge SEGclk) begin
        if (reset) DigitSelect <= 0;
        else  DigitSelect <= DigitSelect + 1;
    end 
    
    always @(*) begin
        case (DigitSelect)
            0: SevenSegmentChar = 0;
            1: SevenSegmentChar = 0;
            2: SevenSegmentChar = 0;
            3: SevenSegmentChar = 0;
            4: SevenSegmentChar = 0;
            5: SevenSegmentChar = 0;
            6: SevenSegmentChar = 0;
            7: SevenSegmentChar = 0;
            default: SevenSegmentChar = 0;
        endcase
    end

endmodule
