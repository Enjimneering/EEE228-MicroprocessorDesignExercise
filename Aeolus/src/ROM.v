// Program ROM 
// ROM : Acts as a insturction storage unit for the CPU

module ProgramROM (    // ROM for the main system 
    input  wire [3:0] addressIn,
    output reg  [3:0] dataOut
);

    always @(*) begin


        case (addressIn)
            0: begin
                dataOut = 4'b0000; //LDA
            end

            1: begin
                dataOut = 4'b0001; //LDB
            end

            2: begin
                dataOut = 4'b1010; //ADD
            end

            3: begin
                dataOut = 4'b0010; //LD O
            end

            4: begin
                dataOut = 4'b1011; //SUB
            end

            5: begin
                dataOut = 4'b0010; //LDO
            end
            
            6: begin
                dataOut = 4'b1110; //XOR
            end

            7: begin
                 dataOut = 4'b0010; //LDO
            end

            8: begin
                 dataOut = 4'b0011; //LDS A
            end

            9: begin
                 dataOut = 4'b0110; //RSH
            end

            10: begin
                 dataOut = 4'b1000; //SNZ A
            end

            11: begin
                 dataOut = 4'b0010; //LDS B
            end

            12: begin
                 dataOut = 4'b0010; //LSH
            end

            13: begin
                 dataOut = 4'b0100; //SNZ S
            end

            14: begin
                 dataOut = 4'b0010; //LDO
            end

            default: begin
                dataOut = 5'b0111; //CLR - basically a NOP operation.
            end

        endcase
    
    end

endmodule

// Program ROM 

module ProgramROM2 (  // Rom built for specific test case 
    input  wire [3:0] addressIn,
    output reg  [3:0] dataOut
);

    always @(*) begin

        case (addressIn)
            0: begin
                dataOut = 4'b0000; //LDA
            end

            1: begin
                dataOut = 4'b0001; //LDB
            end

            2: begin
                 dataOut = 4'b1010; //ADD
            end

            
            3: begin
                 dataOut = 4'b0010; //LDO
            end

            4: begin
                 dataOut = 4'b1011; //SUB
            end

            5: begin
                 dataOut = 4'b0010; //LDO
            end

            6: begin
                 dataOut = 4'b1110; //XOR
            end

            7: begin
                 dataOut = 4'b0010; //LDO
            end

            default: begin
                dataOut = 5'b0111; //CLR - basically a NOP operation.
            end

        endcase
    
    end

endmodule

module ProgramROM3  ( // Conditional Test
    input  wire [3:0] addressIn,
    output reg  [3:0] dataOut
);

    always @(*) begin

        case (addressIn)
            0: begin
                dataOut = 4'b0000; //LDA
            end

            1: begin
                dataOut = 4'b0001; //LDB
            end
            
            2: begin 
                 dataOut = 4'b0011; //LDS A
            end
            
            3: begin
                 dataOut = 4'b0101; // LSH
            end

            4: begin
                 dataOut = 4'b1000; // SNZA
            end
            
            5: begin
                 dataOut = 4'b0010; //LDO
            end

            6: begin
                dataOut = 4'b0000; //LDA
            end
            
            7: begin
                dataOut = 4'b0001; //LDB
            end
            
            8: begin 
                 dataOut = 4'b0011; //LDS A
            end

            9: begin
                 dataOut = 4'b0101; // LSH
            end

            11: begin
                 dataOut = 4'b1000; // SNZA
            end
            
            12: begin
                 dataOut = 4'b0010; //LDO
            end

            default: begin
                dataOut = 5'b0111; //CLR - basically a NOP operation.
            end

        endcase
    
    end

endmodule

