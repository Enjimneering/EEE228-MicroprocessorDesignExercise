//4-bit input number and outputs the corresponding seven-segment display 
`ifndef SEG7MACROS
`define SEG7MACROS

`define CHAR_A 7'b0001000
`define CHAR_B 7'b1100000
`define CHAR_C 7'b1001110
`define CHAR_D 7'b1000010
`define CHAR_E 7'b0000110
`define CHAR_F 7'b0001110
`define CHAR_G 7'b1000010
`define CHAR_H 7'b0001001
`define CHAR_I 7'b1001111
`define CHAR_J 7'b1100011
`define CHAR_K 7'b0001001
`define CHAR_L 7'b1001111
`define CHAR_M 7'b0101010
`define CHAR_N 7'b1101010
`define CHAR_O 7'b0000001
`define CHAR_P 7'b0001100
`define CHAR_Q 7'b0001000
`define CHAR_R 7'b1101010
`define CHAR_S 7'b0010010
`define CHAR_T 7'b0001111
`define CHAR_U 7'b1000001
`define CHAR_V 7'b1011001
`define CHAR_W 7'b1000000
`define CHAR_X 7'b0101010
`define CHAR_Y 7'b0010001
`define CHAR_Z 7'b0100100
`define CHAR_ZERO 7'b0000001
`define CHAR_ONE 7'b1001111
`define CHAR_TWO 7'b0010010
`define CHAR_THREE 7'b0000110
`define CHAR_FOUR 7'b1001100
`define CHAR_FIVE 7'b0100100
`define CHAR_SIX 7'b0100000
`define CHAR_SEVEN 7'b0001111
`define CHAR_EIGHT 7'b0000000
`define CHAR_NINE 7'b0000100
`define CHAR_SPACE 7'b1111111 
      
`endif

module HexDigitDecoder_SEG7 (
    input wire [3:0] num,
    output reg [6:0] segments
);
    
    always @(*) begin
        case (num) // active low 
            4'h0: segments = `CHAR_ZERO; // 0
            4'h1: segments = `CHAR_ONE; // 1
            4'h2: segments = `CHAR_TWO; // 2
            4'h3: segments = `CHAR_THREE; // 3
            4'h4: segments = `CHAR_FOUR; // 4
            4'h5: segments = `CHAR_FIVE; // 5
            4'h6: segments = `CHAR_SIX; // 6
            4'h7: segments = `CHAR_SEVEN; // 7
            4'h8: segments = `CHAR_EIGHT; // 8
            4'h9: segments = `CHAR_NINE; // 9
            4'hA: segments = `CHAR_A; // A
            4'hB: segments = `CHAR_B; // B
            4'hC: segments = `CHAR_C; // C
            4'hD: segments = `CHAR_D; // D
            4'hE: segments = `CHAR_E; // E
            4'hF: segments = `CHAR_F; // F
            default: segments = `CHAR_SPACE; // Blank
        endcase
    end


endmodule

//displays opcode mnemonics on a 4-digit seven-segment display
module OpcodeDisplay_SEG7 (
    input wire [3:0] opcode,      // 4-bit opcode input
    output reg [6:0] digit1,      // Leftmost 7-segment display
    output reg [6:0] digit2,
    output reg [6:0] digit3,
    output reg [6:0] digit4       // Rightmost 7-segment display
);

    always @(*) begin
        case (opcode)
            4'h0: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_D, `CHAR_A, `CHAR_SPACE};  // "LDA"
            4'h1: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_D, `CHAR_B, `CHAR_SPACE};  // "LDB"
            4'h2: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_D, `CHAR_O, `CHAR_SPACE};  // "LDO"
            4'h3: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_D, `CHAR_S, `CHAR_A};      // "LDSA"
            4'h4: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_D, `CHAR_S, `CHAR_B};      // "LDSB"
            4'h5: {digit1, digit2, digit3, digit4} = {`CHAR_L, `CHAR_S, `CHAR_H, `CHAR_SPACE};  // "LSH"
            4'h6: {digit1, digit2, digit3, digit4} = {`CHAR_R, `CHAR_S, `CHAR_H, `CHAR_SPACE};  // "RSH"
            4'h7: {digit1, digit2, digit3, digit4} = {`CHAR_C, `CHAR_L, `CHAR_R, `CHAR_SPACE};  // "CLR"
            4'h8: {digit1, digit2, digit3, digit4} = {`CHAR_S, `CHAR_N, `CHAR_Z, `CHAR_A};      // "SNZA"
            4'h9: {digit1, digit2, digit3, digit4} = {`CHAR_S, `CHAR_N, `CHAR_Z, `CHAR_S};      // "SNZS"
            4'hA: {digit1, digit2, digit3, digit4} = {`CHAR_A, `CHAR_D, `CHAR_D, `CHAR_SPACE};  // "ADD"
            4'hB: {digit1, digit2, digit3, digit4} = {`CHAR_S, `CHAR_U, `CHAR_B, `CHAR_SPACE};  // "SUB"
            4'hC: {digit1, digit2, digit3, digit4} = {`CHAR_A, `CHAR_N, `CHAR_D, `CHAR_SPACE};  // "AND"
            4'hD: {digit1, digit2, digit3, digit4} = {`CHAR_O, `CHAR_R, `CHAR_SPACE, `CHAR_SPACE};  // "OR"
            4'hE: {digit1, digit2, digit3, digit4} = {`CHAR_X, `CHAR_O, `CHAR_R, `CHAR_SPACE};  // "XOR"
            4'hF: {digit1, digit2, digit3, digit4} = {`CHAR_I, `CHAR_N, `CHAR_V, `CHAR_SPACE};  // "INV"
            default: {digit1, digit2, digit3, digit4} = {`CHAR_SPACE, `CHAR_SPACE, `CHAR_SPACE, `CHAR_SPACE};  // Blank display
        endcase

    end

endmodule
