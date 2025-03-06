// header file for test macros

`define assert(signal, value) if (signal !== value) begin  $display("ASSERTION FAILED for Test at time %0t ns : %m signal  !=  value expected: %5b, got: %5b" , $time , value, signal); $finish; end
