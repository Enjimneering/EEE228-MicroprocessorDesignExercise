// Program ROM 
// ROM : Acts as a insturction storage unit for the CPU

module ProgramROM (    // ROM for the main system 
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);
    parameter ADDR_WIDTH = 8;

    always @(*) begin
        case (addressIn)
            0:  dataOut = 4'b0000; // LDA
            1:  dataOut = 4'b0001; // LDB
            2:  dataOut = 4'b1010; // ADD
            3:  dataOut = 4'b0010; // LD O
            4:  dataOut = 4'b1011; // SUB
            5:  dataOut = 4'b0010; // LDO
            6:  dataOut = 4'b1110; // XOR
            7:  dataOut = 4'b0010; // LDO
            8:  dataOut = 4'b0011; // LDS A
            9:  dataOut = 4'b0110; // RSH
            10: dataOut = 4'b1000; // SNZ A
            11: dataOut = 4'b0010; // LDS B
            12: dataOut = 4'b0010; // LSH
            13: dataOut = 4'b0100; // SNZ S
            14: dataOut = 4'b0010; // LDO
            default: dataOut = 5'b0111; // CLR - basically a NOP operation.
        endcase
    end

endmodule


// Program ROM 

module ProgramROM2 (  // Rom built for specific test case 
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);
    parameter ADDR_WIDTH = 4;

    always @(*) begin

        case (addressIn)
            0: dataOut = 4'b0000; //LDA
            1: dataOut = 4'b0001; //LDB
            2: dataOut = 4'b1010; //ADD
            3: dataOut = 4'b0010; //LDO
            4: dataOut = 4'b1011; //SUB
            5: dataOut = 4'b0010; //LDO
            6: dataOut = 4'b1110; //XOR
            7: dataOut = 4'b0010; //LDO
            default: dataOut = 5'b0111; //CLR - basically a NOP operation.
        endcase
    
    end

endmodule

module ProgramROM3  ( // Conditional ADD Test
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);

    parameter ADDR_WIDTH = 4;
    always @(*) begin

        case (addressIn)
            0:  dataOut = 4'b0000;  // LDA
            1:  dataOut = 4'b0011;  // LDS A
            2:  dataOut = 4'b0101;  // LSH
            3:  dataOut = 4'b0101;  // LSH
            4:  dataOut = 4'b0101;  // LSH
            5:  dataOut = 4'b0010;  // LDO
            6:  dataOut = 4'b0001;  // LDB
            7:  dataOut = 4'b0100;  // LDS B
            8:  dataOut = 4'b0110;  // RSH
            9:  dataOut = 4'b0110;  // RSH
            10: dataOut = 4'b0010; // LDO
            default: dataOut = 5'b0111; //CLR - basically a NOP operation.
            
        endcase
    
    end

endmodule

module InstructionROM (                      // Stores every instructino
  input wire [ADDR_WIDTH-1:0] addressIn,
  output reg  [3:0] dataOut
);
  parameter ADDR_WIDTH = 4;
   
   always @(*) begin
        case (addressIn)
            0:  dataOut = 0;  //LDA
            1:  dataOut = 1;  //LDB
            2:  dataOut = 2;  //LDSB
            3:  dataOut = 3;  //RSH
            4:  dataOut = 4;  //SNZ A
            5:  dataOut = 5;  //RSH
            6:  dataOut = 6;  //LDSA
            7:  dataOut = 8;  //LSH
            8:  dataOut = 9;  //SNZ S
            9:  dataOut = 10; //LDSB
            10: dataOut = 11; //RSH
            11: dataOut = 12; //RSH
            12: dataOut = 13; //RSH
            13: dataOut = 14; //LDSA
            14: dataOut = 15; //LSH
            default: dataOut = 7; //CLR
        endcase
     end
endmodule


module ProgramROMtest (
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);
    
    parameter ADDR_WIDTH = 8;

    always @(*) begin
        case (addressIn)
            0:  dataOut = 4'b0000;  //LDA
            1:  dataOut = 4'b0001;  //LDB
            2:  dataOut = 4'b0100;  //LDSB
            3:  dataOut = 4'b0110;  //RSH
            4:  dataOut = 4'b1000;  //SNZ A
            5:  dataOut = 4'b0110;  //RSH
            6:  dataOut = 4'b0011;  //LDSA
            7:  dataOut = 4'b0101;  //LSH
            8:  dataOut = 4'b1001;  //SNZ S
            9:  dataOut = 4'b0100;  //LDSB
            10: dataOut = 4'b0110;  //RSH
            11: dataOut = 4'b0110;  //RSH
            12: dataOut = 4'b0110;  //RSH
            13: dataOut = 4'b0011;  //LDSA
            14: dataOut = 4'b0101;  //LSH
            15: dataOut = 4'b0101;  //LSH
            16: dataOut = 4'b1001;  //SNZ S
            17: dataOut = 4'b0100;  //LDSB
            18: dataOut = 4'b0110;  //RSH
            19: dataOut = 4'b0110;  //RSH
            20: dataOut = 4'b0110;  //RSH
            21: dataOut = 4'b0110;  //RSH
            22: dataOut = 4'b0011;  //LDSA
            23: dataOut = 4'b0101;  //LSH
            24: dataOut = 4'b0101;  //LSH
            25: dataOut = 4'b0101;  //LSH
            26: dataOut = 4'b1001;  //SNZS
            27: dataOut = 4'b0010;  //LDO
            28: dataOut = 4'b0111;  //CLR
            29: dataOut = 4'b0111;  //CLR
            30: dataOut = 4'b0111;  //CLR
            31: dataOut = 4'b0111;  //CLR
            default: dataOut = 4'b0111; //CLR - basically a NOP operation.
        endcase
    end 
endmodule
