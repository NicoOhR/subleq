`timescale 1ns/1ps

module tb_alu;
  logic clk;

  alu_bus bus();

  alu dut (
    bus.ALU
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

    bus.a_i = 5; bus.b_i = 4;
    @(posedge clk); #1;
    bus.a_i = -2; bus.b_i = 3;
    @(posedge clk); #1;
    bus.a_i = -120; bus.b_i = 120;
    @(posedge clk); #1;

    $finish;
  end
endmodule
