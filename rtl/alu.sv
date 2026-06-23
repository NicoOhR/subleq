module alu (
  alu_bus.ALU bus
);
  assign bus.b_o = bus.b_i - bus.a_i;
  assign bus.s_o[1] = (bus.a_i[7] ^ bus.b_i[7]) & (bus.a_i[7] ^ bus.b_o[7]); //overflow
  assign bus.s_o[0] = bus.b_o[7] | bus.s_o[1]; // branch
endmodule
