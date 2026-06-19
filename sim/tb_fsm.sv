`timescale 1ns/1ps

module tb_fsm;
  logic clk;

  alu_bus alu_bus_if ();
  mem_bus mem_bus_if (clk);

  alu alu (alu_bus_if);
  mem mem (clk, mem_bus_if);
  fsm fsm (clk, mem_bus_if, alu_bus_if);

  initial begin
    clk = 0;
  end
  always begin
    #5 clk = ~clk;
  end

  initial begin
    //1 2 2, a - b = -1 -> branch in place -> HALT
    mem.mem[0] = 16'd1;
    mem.mem[1] = 16'd2;
    mem.mem[2] = 16'd2;

    //mem.mem[3] = 16'd2;
    //mem.mem[4] = 16'd5;
    //mem.mem[5] = 16'd0;
  end

  initial begin
    $dumpfile("out/fsm.vcd");
    $dumpvars(0, tb_fsm);
    #200 $finish;
  end
endmodule
