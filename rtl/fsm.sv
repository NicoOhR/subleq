module fsm (
  input logic clk,
  mem_bus.FSM mem_b,
  alu_bus.FSM alu_b
);

  typedef enum logic [7:0]
    {
      RESET,
      FETCH_A,
      FETCH_B,
      FETCH_C,
      BRANCH
    } state_t;

  assign state = state_t'(8'b0);

  logic [15:0] tmp_a, tmp_b, tmp_c, pc;
  assign alu_b.a_i = tmp_a;
  assign alu_b.b_i = tmp_b;

  // set the address on the cycle before to let the
  // RAM read go through.
  always_ff @(posedge clk) begin : fsm
    case(state)
      RESET: begin
        pc <= 8'b0;
        mem_b.addr <= pc;
        state <= FETCH_A;
    end
      FETCH_A: begin
        tmp_a <= mem_b.data_out;

        pc <= pc + 1;
        mem_b.addr <= pc;
        state <= FETCH_B;
    end
      FETCH_B: begin
        tmp_b <= mem_b.data_out;

        pc <= pc + 1;
        mem_b.addr <= pc;
        state <= FETCH_C;
    end
      FETCH_C: begin
        tmp_c <= mem_b.data_out;

        pc <= pc + 1;
        mem_b.addr <= pc;
        state <= BRANCH;
    end
      BRANCH: begin
        //write back the result from the ALU
        mem_b.addr <= pc - 2;
        mem_b.data_in <= alu_b.b_o;
        mem_b.we <= 4'b1111;

        if(alu_b.s_o[0]) begin
          pc <= tmp_c;
        end else begin
          pc <= pc + 1;
        end

        state <= FETCH_A;
    end
      default: begin
    end
    endcase
  end
endmodule
