// Control Modules

// CLK Div to create system CLK 

module clkDiv(
    input wire CLKin,
    output wire CLKout
    );

    parameter COUNTER_SIZE = 64; 
    parameter COUNTER_TARGET = 1;

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

// Multiplexers

module SR_MUX (
    input wire _LDSA,
    input wire _LDSB,
    input wire Aout,
    input wire Bout,
    output reg shiftIn
);
    always @(*) begin
        if (_LDSA) begin
           shiftIn = Aout;
        end else if (_LDSB) begin
           shiftIn = Bout;
        end else begin
           shiftIn = 0 ;
        end
    end
endmodule

module ADD_MUX (
    input wire _ADD,
    input wire _SNZA,
    input wire _SNZS,
    input wire SF,
    output reg _ADDin
);
 
 always @(*) begin 

        if ((_SNZA |_SNZS)) begin
        if (SF == 1) _ADDin = 1;
        else  _ADDin = _ADD;
        end else begin
            _ADDin = _ADD;
        end
    end 

endmodule

module ALU_MUX (
    input wire _SNZA,
    input wire SF,
    input wire _SNZS,
    input wire shiftOut,
    input wire ACCout,
    input wire Aout,
    input wire Bout,
    output reg in1,
    output reg in2
);

    always @(*) begin 
        // set ALU inputs
        if ((_SNZA == 1  && SF == 1))  begin         // add ACC and Reg A .
            in1 = Aout;
            in2 = ACCout;

        end else if ((_SNZS == 1 && SF == 1)) begin  // add ACC and Shifter
            in1 = shiftOut;
            in2 = ACCout;

        end else begin // non conditional instructinos
            in1 = Aout;
            in2 = Bout;
        end
    end
endmodule
