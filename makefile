RTL_DIR := rtl
SIM_DIR := sim
OUT_DIR := out

TBS 		:= $(wildcard $(SIM_DIR)/tb_*.sv)
RTL_SRCS:= $(wildcard $(RTL_DIR)/*.sv)
TARGETS := $(patsubst $(SIM_DIR)/tb_%.sv, $(OUT_DIR)/%.out, $(TBS))

.PHONY: all clean

all: $(TARGETS)

$(OUT_DIR)/%.out: $(SIM_DIR)/tb_%.sv $(RTL_SRCS) | $(OUT_DIR)
	verilator --binary --timing --trace +define+SIM_TARGET +define+FSM_DEBUG -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND --top-module tb_$* -Mdir $(OUT_DIR)/$*_obj -o $(abspath $@) $(SIM_DIR)/tb_$*.sv $(RTL_SRCS)
	$@

$(OUT_DIR):
	mkdir -p $@

clean: 
	rm -rf $(OUT_DIR)
