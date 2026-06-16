interface alu_bus;
  logic signed[15:0] a_i, b_i, b_o;
  logic[1:0] s_o;
 
  modport ALU (
    input a_i, b_i,
    output b_o, s_o
  );
  modport FSM (
    input b_o, s_o,
    output a_i, b_i
  );
endinterface
