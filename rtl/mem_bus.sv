interface mem_bus
  #(
    parameter int WIDTH=16,
    parameter int DEPTH=16384,
    localparam int ADDRW=$clog2(DEPTH)
  )(
    input clk
  );
    logic [3:0] we;
    logic [ADDRW-1:0] addr;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;

    modport FSM (output we, addr, data_in,
                 input data_out,clk);
    modport MEM (input we, addr, data_in,
                 output data_out,clk);
endinterface
