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
    // SUBLEQ at PC=0: A_addr=3, B_addr=4, C=2
    // val_b - val_a = 3 - 5 = -2  =>  write mem[4] = -2 (0xFFFE)
    // C=2 = pc+2 => halt condition fires
    mem.mem[0] = 16'd3;   // A_addr
    mem.mem[1] = 16'd4;   // B_addr
    mem.mem[2] = 16'd2;   // C (= pc+2 → HALT)
    mem.mem[3] = 16'd5;   // mem[A] = val_a
    mem.mem[4] = 16'd3;   // mem[B] = val_b (expect 0xFFFE after write)
  end

  initial begin
    $dumpfile("out/fsm.vcd");
    $dumpvars(0, tb_fsm);
    #200;
    $display("mem[4] = 0x%04h (expect 0xFFFE)", mem.mem[4]);
    $finish;
  end
endmodule
