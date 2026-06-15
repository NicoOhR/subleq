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
    logic [bus.WIDTH-1:0] ram [bus.DEPTH];

    always_ff @(posedge clk) begin : regfile
        if(bus.we[0]) ram[bus.addr][3:0]   <= bus.data_in[3:0];
        if(bus.we[1]) ram[bus.addr][7:4]   <= bus.data_in[7:4];
        if(bus.we[2]) ram[bus.addr][11:8]  <= bus.data_in[11:8];
        if(bus.we[3]) ram[bus.addr][15:12] <= bus.data_in[15:12];
        bus.data_out <= ram[bus.addr];
    end
`endif
endmodule

