module fsm (
  input logic clk,
  mem_bus.FSM mem_b,
  alu_bus.FSM alu_b
);

  typedef enum logic [7:0]
    {
      RESET,
      WAIT,
      FETCH_A,
      FETCH_B,
      FETCH_C,
      WRITE,
      BRANCH
    } state_t;

  state_t state;

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
        mem_b.cs <= 1;
        mem_b.slp <= 0;
        mem_b.pwr <= 1;
        mem_b.sb <= 0;
        mem_b.we <= 4'b0;
        state <= WAIT;
    end
      WAIT: begin
        state <= FETCH_A;

        mem_b.addr <= pc + 1;
    end
      FETCH_A: begin
        tmp_a <= mem_b.data_out;

        mem_b.addr <= pc + 2;
        state <= FETCH_B;
    end
      FETCH_B: begin
        tmp_b <= mem_b.data_out;
        state <= FETCH_C;
    end
      FETCH_C: begin
        tmp_c <= mem_b.data_out;
        state <= WRITE;
    end
      WRITE: begin
        mem_b.addr <= pc + 1;
        mem_b.data_in <= alu_b.b_o;
        mem_b.we <= 4'b1111;
        state <= BRANCH;
    end
      BRANCH: begin
        mem_b.we <= 5'b0;
        if(alu_b.s_o[0]) begin
          mem_b.addr <= tmp_c;
          pc <= tmp_c;
        end else begin
          mem_b.addr <= pc + 3;
          pc <= pc + 3;
        end
        state <= WAIT;
    end
      default: begin
    end
    endcase
  end
endmodule
