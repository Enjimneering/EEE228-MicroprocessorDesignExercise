// Control Modules

// CLK Div to create system CLK 

module clkDiv(
    input wire CLKin,
    output wire CLKout
    );

    localparam COUNTER_SIZE = 64; 
    localparam COUNTER_TARGET = 1;

// T(clkOut) / T(clkin) = Countersize / counter target

    reg[COUNTER_SIZE - 1:0] counter = 0;

   always @(posedge CLKin) begin
        counter <= counter  + 1;
   end

   assign CLKout = counter[COUNTER_TARGET];

endmodule

module Counter_2bit(
    input            clk,
    input            reset,
    input            enable,
    output reg [1:0] value
);

    always @(posedge clk ) begin
        if (~reset) begin
            if (enable) begin
                value <= value + 1;   
            end
        end else begin
            value <= 0;
        end
      
    end


endmodule

// Instruction Decoder to map opcodes to control signals.
// 1762

module InstructionDecoder(
    input  [3:0] instructionIn,
    output       LDA,
    output       LDB,
    output       LDO,
    output       LDSA,
    output       LDSB,
    output       LSH,
    output       RSH,
    output       CLR,
    output       SNZA,
    output       SNZS,
    output       ADD,
    output       SUB,
    output       AND,
    output       OR,
    output       XOR,
    output       INV
);
    // 1-hot control signal encoding
    reg [15:0] ControlSignals; 
    
    always @(*) begin
        ControlSignals = 16'b0000_0000_0000_0001 << instructionIn;
    end

    assign {INV,XOR,OR,AND,SUB,ADD,SNZS,SNZA,CLR,RSH,LSH,LDSB,LDSA,LDO,LDB,LDA} = ControlSignals;
    

endmodule


