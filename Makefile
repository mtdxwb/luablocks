BIN_SOURCE=bin
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

.PHONY: install
