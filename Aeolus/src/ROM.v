// Program ROM 

module ProgramROM (
    input wire clk,
    input  wire [3:0] addressIn,
    output reg  [3:0] dataOut
);

    always @(posedge clk) begin


        case (addressIn)
            0: begin
                dataOut <= 4'b0000; //LDA
            end

            1: begin
                dataOut <= 4'b0001; //LDB
            end

            2: begin
                dataOut <= 4'b1110; //XOR
            end

            3: begin
                dataOut <= 4'b0010; //LDO
            end

            default: begin
                dataOut <= 5'b0111; //CLR
            end

        endcase
    
    end

endmodule