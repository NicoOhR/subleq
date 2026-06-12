module alu (
  input logic signed[7:0] a_i,  b_i,
  input logic clk,
  output logic signed[7:0] b_o,
  output logic s_o
);
  assign b_o = a_i - b_i;
  always_ff @(posedge clk) begin : status
    if (b_o[7]) begin 
      s_o <= 1'b1;
    end else begin 
      s_o <= 1'b0;
    end
  end
endmodule
