
//Register File

module RegisterFile (
    input                      clk,
    input                      reset,
    input  [INPUT_WIDTH -1:0]  AIn,
    input  [INPUT_WIDTH -1:0]  BIn,
    input  [OUTPUT_WIDTH -1:0] OIn,
    input                      LDA,
    input                      LDB,
    input                      LDO,
    output [INPUT_WIDTH -1:0]  Aout,
    output [INPUT_WIDTH -1:0]  Bout,
    output [OUTPUT_WIDTH-1:0]  Oout
);

    parameter OUTPUT_WIDTH = 8;
    parameter INPUT_WIDTH = 4;

    reg [3:0] Ain, Bin;

    always @(*) begin
        if (reset) begin// asynch reset
            Ain = 0;
            Bin = 0;
        end else begin
            Ain = AIn;
            Bin = BIn;
        end   
    end
    
    // A register
    EnableDFF_4bit RegA (clk, LDA, Ain, Aout);

    // B register
    EnableDFF_4bit RegB (clk, LDB, Bin, Bout);

    // O register
    EnableDFF RegO (clk, LDO, OIn, Oout);
    defparam RegO.DATA_WIDTH = 8;


endmodule

// Register Templates
module DFF_4bit ( //DFF used just for buffering signals
    input wire clk,
    input wire [3:0] D,
    output reg [3:0] Q
);

    always @(posedge clk) begin
            Q <= D;
    end

endmodule

module DFF (   //DFF used just for buffering signals
    input wire clk,
    input wire  D,
    output reg  Q
);

    always @(posedge clk) begin
            Q <= D;
    end

endmodule

module EnableDFF_4bit(
    input wire clk,
    input wire enable,
    input wire [3:0] D,
    output reg [3:0] Q
);

    always @(posedge clk) begin
        if (enable) begin
            Q <= D;
        end 
    end

endmodule

//Paramatreised width

module EnableDFF(
    input wire clk,
    input wire enable,
    input wire [DATA_WIDTH-1:0] D,
    output reg [DATA_WIDTH-1:0] Q
);
    parameter DATA_WIDTH   = 4;

    always @(posedge clk) begin
        if (enable) begin
            Q <= D;
        end 
    end

endmodule

module ResetEnableDFF ( // synchronous reset
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [DATA_WIDTH-1:0] D,
    output reg [DATA_WIDTH-1:0] Q
);

    parameter DATA_WIDTH = 4;

    always @(posedge clk) begin

        if (~reset) begin
            if (enable) begin
                Q <= D;
            end 

        end else begin // reset behaviour
            Q <= 0;
        end
    end

endmodule

module ResetEnableDFF_4bit( // synchronous reset
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] D,
    output reg [3:0] Q
);
    always @(posedge clk) begin
        if (~reset) begin
            if (enable) begin
                Q <= D;
            end 
        end else begin // reset behaviour
            Q <= 0;
        end
    end

endmodule

module ResetDFF_4bit ( // synchronous reset, no enable
    input wire clk,
    input wire reset,
    input wire [3:0] D,
    output reg [3:0] Q
);

    always @(posedge clk) begin
        if (~reset) begin
            Q <= D;
        end else begin // reset behaviour
            Q <= 0;
        end
    end

endmodule

module ResetDFF ( // synchronous reset, no enable
    input wire clk,
    input wire reset,
    input wire [DATA_WIDTH-1:0] D,
    output reg [DATA_WIDTH-1:0] Q
);
    parameter   DATA_WIDTH = 8;

    always @(posedge clk) begin
        if (~reset) begin
            Q <= D;
        end else begin // reset behaviour
            Q <= 0;
        end
    end

endmodule


// Shift Register
// sequential shift register with mux for inputs - flag implimented for RSH underflow

module ShiftRegister ( 
    input wire       clk,
    input wire       reset,
    input wire [3:0] in,
    input wire       loadEnable,
    input wire [1:0] shiftState,
    output reg [3:0] out,
    output reg       flag
);

    always @(posedge clk) begin
       
       if (~reset) begin
            
               if (loadEnable) begin
                    out <= in;
                    flag <= flag;
                end

                else if (~loadEnable)begin
        
                    if (shiftState == 2'b10) begin   //LSH
                        out <= {out[2:0],1'b0};
                        flag <= flag;
                    end

                    else if (shiftState == 2'b01) begin // RSH
                        out <= {1'b0, out[3:1]};
                        flag <= out[0]; // LSB of RSH is the flag (underflow)
                    end

                    else if (~(shiftState[0] ^ shiftState[1])) begin // no instructino
                        out <= out;
                        flag <= flag;
                    end
                end

        end else begin// reset logic   
            out <= 0;
            flag <= 0;
        end

    end

endmodule