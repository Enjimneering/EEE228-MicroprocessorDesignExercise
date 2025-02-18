// Control Modules

// System Clock

module clkDiv(
    input wire CLKin,
    output wire CLKout
    );

localparam COUNTER_SIZE = 32; 
localparam COUNTER_TARGET = 2;

// T(clkOut) / T(clkin) = Countersize / counter target

reg[COUNTER_SIZE - 1:0] counter = 0;

   always @(posedge CLKin) begin
        counter <= counter  + 1;
   end

   assign CLKout = counter[COUNTER_TARGET];

endmodule



