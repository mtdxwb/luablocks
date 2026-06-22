BIN_SOURCE=bin
CONFIG_DIR=~/.config/luablocks
MUBIAO_BIN=~/.local/bin
MUBIAO_BIN_ROOT=/usr/local/bin

install:
	@if [ $$(id -u) -eq 0 ]; then \
		sudo mkdir -p $(MUBIAO_BIN_ROOT); \
		sudo cp $(BIN_SOURCE)/* $(MUBIAO_BIN_ROOT); \
	else \
		mkdir -p $(MUBIAO_BIN); \
		cp $(BIN_SOURCE)/* $(MUBIAO_BIN); \
	fi

config:
	@mkdir -p $(CONFIG_DIR)
	@cp ./config.lua $(CONFIG_DIR)/
	@cp -r ./blocks $(CONFIG_DIR)/

.PHONY: install
