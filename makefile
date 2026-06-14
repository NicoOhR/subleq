RTL_DIR := rtl
SIM_DIR := sim
OUT_DIR := out

TBS 		:= $(wildcard $(SIM_DIR)/tb_*.sv)
DUTS 		:= $(patsubst $(SIM_DIR)/tb_%.sv, $(RTL_DIR)/%.sv, $(TBS))
TARGETS := $(patsubst $(SIM_DIR)/tb_%.sv, $(OUT_DIR)/%.out, $(TBS))
IFACES  := $(wildcard $(RTL_DIR)/*_bus.sv)

.PHONY: all clean

all: $(TARGETS)

$(OUT_DIR)/%.out: $(SIM_DIR)/tb_%.sv $(RTL_DIR)/%.sv $(IFACES) | $(OUT_DIR)
	iverilog -g2012 -o $@ $^
	vvp $@

$(OUT_DIR):
	mkdir -p $@

clean: 
	rm -rf $(OUT_DIR)
