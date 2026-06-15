`timescale 1ns/1ps

module tb_fsm;
  logic clk;

  alu_bus alu_bus_if (clk);
  mem_bus mem_bus_if (clk);

endmodule;
