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
      VAL_A,
      VAL_B,
      WRITE,
      BRANCH,
      HALT
    } state_t;

  state_t state;
  logic [15:0] addr_a, addr_b, addr_c, pc;
  logic [15:0] val_a, val_b;

  assign alu_b.a_i = val_a;
  assign alu_b.b_i = val_b;

  always_ff @(posedge clk) begin : fsm
    case(state)
      HALT: begin
        state <= HALT;
      end
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
        mem_b.addr <= pc + 1;
        state <= FETCH_A;
    end
      FETCH_A: begin
        addr_a <= mem_b.data_out;
        mem_b.addr <= pc + 2;
        state <= FETCH_B;
    end
      FETCH_B: begin
        addr_b <= mem_b.data_out;
        mem_b.addr <= addr_a;
        state <= FETCH_C;
    end
      FETCH_C: begin
        addr_c <= mem_b.data_out;
        mem_b.addr <= addr_b;
        state <= VAL_A;
    end
      VAL_A: begin
        val_a <= mem_b.data_out;
        state <= VAL_B;
    end
      VAL_B: begin
        val_b <= mem_b.data_out;
        state <= WRITE;
    end
      WRITE: begin
        mem_b.addr <= addr_b;
        mem_b.data_in <= alu_b.b_o;
        mem_b.we <= 4'b1111;
        state <= BRANCH;
    end
      BRANCH: begin
        mem_b.we <= 0;
        if ((pc + 2) == addr_c) begin
          state <= HALT;
        end else begin
          if(alu_b.s_o[0]) begin
            mem_b.addr <= addr_c;
            pc <= addr_c;
          end else begin
            mem_b.addr <= pc + 3;
            pc <= pc + 3;
          end
          state <= WAIT;
      end
    end
      default: begin
    end
    endcase
  end
endmodule
