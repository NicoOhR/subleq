module mem(input clk,mem_bus bus);

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
endmodule

