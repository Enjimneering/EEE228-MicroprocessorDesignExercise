// Program ROM 
// ROM : Acts as a insturction storage unit for the CPU

module ProgramROM (    // ROM for the main system 
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);
    parameter ADDR_WIDTH = 8;

    always @(*) begin
     
          case (addressIn)
               0: dataOut = 4'b0000; // LDA
               1: dataOut = 4'b0001; // LDB
               2: dataOut = 4'b1010; // ADD
               3: dataOut = 4'b0010; // LD O
               4: dataOut = 4'b1011; // SUB
               5: dataOut = 4'b0010; // LDO
               6: dataOut = 4'b1110; // XOR
               7: dataOut = 4'b0010; // LDO
               8: dataOut = 4'b0011; // LDS A
               9: dataOut = 4'b0110; // RSH
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
            0: dataOut = 4'b0000;  // LDA
            1: dataOut = 4'b0011;  // LDS A
            2: dataOut = 4'b0101;  // LSH
            3: dataOut = 4'b0101;  // LSH
            4: dataOut = 4'b0101;  // LSH
            5: dataOut = 4'b0010;  // LDO
            6: dataOut = 4'b0001;  // LDB
            7: dataOut = 4'b0100;  // LDS B
            8: dataOut = 4'b0110;  // RSH
            9: dataOut = 4'b0110;  // RSH
            10: dataOut = 4'b0010; // LDO
            default: dataOut = 5'b0111; //CLR - basically a NOP operation.
            
        endcase
    
    end

endmodule

module InstructionROM (
  input wire [ADDR_WIDTH-1:0] addressIn,
  output reg  [3:0] dataOut
);
  parameter ADDR_WIDTH = 4;
   
   
   always @(*) begin
        case (addressIn)
    
            0: begin
                dataOut = 0; //LDA
            end

            1: begin
                dataOut = 1; //LDB
            end

            2: begin
                 dataOut = 2; //LDSB
            end
            
            3: begin
                 dataOut = 3; //RSH
            end

            4: begin
                 dataOut = 4; //SNZ A
            end

            5: begin
                 dataOut = 5; //RSH
            end

            6: begin
                 dataOut = 6; //LDSA
            end

            7: begin
                 dataOut = 8;  //LSH
            end

            8: begin
                 dataOut = 9; //SNZ S
            end

            9: begin
                 dataOut = 10; //LDSB
            end

            10: begin
                 dataOut = 11; //RSH
            end

            11: begin
                 dataOut = 12; //RSH
            end

            12: begin
                 dataOut = 13; //RSH
            end

            13: begin
                 dataOut = 14; //LDSA
            end

            14: begin
                 dataOut = 15; //LSH
            end
            
            default : begin
                 dataOut = 7; //CLR
            end

        endcase
     end

endmodule


module ProgramROMtest (  // Rom built for specific test case 
    input  wire [ADDR_WIDTH-1:0] addressIn,
    output reg  [3:0] dataOut
);
    
    parameter ADDR_WIDTH = 8;

    always @(*) begin

        case (addressIn)
            0: begin
                dataOut = 4'b0000; //LDA
            end

            1: begin
                dataOut = 4'b0001; //LDB
            end

            2: begin
                 dataOut = 4'b0100; //LDSB
            end
            
            3: begin
                 dataOut = 4'b0110; //RSH
            end

            4: begin
                 dataOut = 4'b1000; //SNZ A
            end

            5: begin
                 dataOut = 4'b0110; //RSH
            end

            6: begin
                 dataOut = 4'b0011; //LDSA
            end

            7: begin
                 dataOut = 4'b0101;  //LSH
            end

            8: begin
                 dataOut = 4'b1001; //SNZ S
            end

            9: begin
                 dataOut = 4'b0100; //LDSB
            end

            10: begin
                 dataOut = 4'b0110; //RSH
            end

            11: begin
                 dataOut = 4'b0110; //RSH
            end

            12: begin
                 dataOut = 4'b0110; //RSH
            end

            13: begin
                 dataOut = 4'b0011; //LDSA
            end

            14: begin
                 dataOut = 4'b0101; //LSH
            end

            15: begin
                 dataOut = 4'b0101; //LSH
            end

            16: begin
                 dataOut = 4'b1001; //SNZ S
            end

            17: begin
                 dataOut = 4'b0100; //LDSB
            end

            18: begin
                 dataOut = 4'b0110; //RSH
            end

            19: begin
                 dataOut = 4'b0110; //RSH
            end

            20: begin
                 dataOut = 4'b0110; //RSH
            end

            21: begin
                 dataOut = 4'b0110; //RSH
            end

            22: begin
                 dataOut = 4'b0011; //LDSA
            end

            23: begin
                 dataOut = 4'b0101; //LSH
            end

            24: begin
                 dataOut = 4'b0101; //LSH
            end

            25: begin
                 dataOut = 4'b0101; //LSH
            end

            26: begin
                 dataOut = 4'b1001; //SNZS
            end

            27: begin
                 dataOut = 4'b0010; //LDO
            end

            28: begin
                 dataOut = 4'b0111; //CLR
            end

            29: begin
                 dataOut = 4'b0111; //CLR
            end

            30: begin
                 dataOut = 4'b0111; //CLR
            end

            31: begin
                 dataOut = 4'b0111; //CLR
            end
            default: begin
                dataOut = 4'b0111; //CLR - basically a NOP operation.
            end

        endcase
    end 
endmodule 

