
//Register File

module RegisterFile (
    input        clk,
    input        reset,
    input [3:0]  AIn,
    input [3:0]  BIn,
    input [3:0]  OIn,
    input        LDA,
    input        LDB,
    input        LDO,
    output [3:0] Aout,
    output [3:0] Bout,
    output [3:0] Oout
);

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
    
    EnableDFF_4bit RegO (clk, LDO, OIn, Oout);


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

module DFF ( //DFF used just for buffering signals
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

