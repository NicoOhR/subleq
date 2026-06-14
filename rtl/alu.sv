module alu (
  input logic signed[7:0] a_i,  b_i,
  output logic signed[7:0] b_o,
  output logic[1:0] s_o
);
  assign b_o = a_i - b_i;
  assign s_o[1] = (a_i[7] ^ b_i[7]) & (a_i[7] ^ b_o[7]); //overflow
  assign s_o[0] = b_o[7] | s_o[1]; // branch
endmodule
