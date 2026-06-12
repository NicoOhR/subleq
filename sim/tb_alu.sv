`timescale 1ns/1ps

module tb_alu;
  logic clk;
  logic signed [7:0] a, b, r;
  logic s;

  alu dut (
    a, b, clk, r, s
  );
  initial begin
    clk = 0;
  end
  always begin 
    #5 clk = ~clk;
  end 

  initial begin
    $dumpfile("out/alu.vcd");
    $dumpvars(0, tb_alu);

    a = 5; b = 4;
    @(posedge clk); #1; 
    
    a = 1; b = 3;
    @(posedge clk); #1; 

    $finish;
  end
endmodule
