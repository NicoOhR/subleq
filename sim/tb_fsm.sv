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
    // 10 3 8
    // 2 5 0
    mem.mem[0] = 16'd10;
    mem.mem[1] = 16'd3;
    mem.mem[2] = 16'd8;

    mem.mem[3] = 16'd2;
    mem.mem[4] = 16'd5;
    mem.mem[5] = 16'd0;
  end

  initial begin
    $dumpfile("out/fsm.vcd");
    $dumpvars(0, tb_fsm);

    //$monitor("t=%0t state=%-7s pc=%0d tmp_a=%0d tmp_b=%0d tmp_c=%0d alu_b_o=%0d branch=%0d mem[1]=%0d mem[4]=%0d",
    //         $time, fsm.state.name(), fsm.pc, fsm.tmp_a, fsm.tmp_b, fsm.tmp_c,
    //         alu_bus_if.b_o, alu_bus_if.s_o[0], mem.ram[1], mem.ram[4]);
    #200 $finish;
  end
endmodule
