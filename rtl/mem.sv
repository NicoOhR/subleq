module mem(input clk,mem_bus bus);
`ifdef FPGA_TARGET
    SB_SPRAM256KA spram_inst (
        .ADDRESS(bus.addr),
        .DATAIN(bus.data_in),
        .MASKWREN(bus.we),
        .WREN(|bus.we),
        .CHIPSELECT(1'b1),
        .CLOCK(clk),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(bus.data_out)
    );
`endif

`ifdef SIM_TARGET
    reg [15:0] mem [0:16383] /* verilator public */;
    wire off = bus.slp || !bus.pwr;
    integer i;

    always @(negedge bus.pwr) begin
        for (i = 0; i <= 16383; i = i+1)
            mem[i] = 'bx;
    end

    always @(posedge clk, posedge off) begin
        if (off) begin
            bus.data_out <= 0;
        end else
        if (bus.cs && !bus.sb && !(|bus.we)) begin
            bus.data_out <= mem[bus.addr];
        end else begin
            if (bus.cs && !bus.sb && (|bus.we)) begin
                if (bus.we[0]) mem[bus.addr][ 3: 0] = bus.data_in[ 3: 0];
                if (bus.we[1]) mem[bus.addr][ 7: 4] = bus.data_in[ 7: 4];
                if (bus.we[2]) mem[bus.addr][11: 8] = bus.data_in[11: 8];
                if (bus.we[3]) mem[bus.addr][15:12] = bus.data_in[15:12];
            end
            bus.data_out <= 'bx;
        end
    end
`endif
endmodule

