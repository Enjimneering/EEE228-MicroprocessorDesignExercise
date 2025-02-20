// Registers

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