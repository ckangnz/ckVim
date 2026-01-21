SHELL := /bin/bash
VIM_DIR := $(HOME)/.vim
SCRIPTS_DIR := $(VIM_DIR)/scripts

# Helper function to source brew environment
define SETUP_BREW
	if [ -f /opt/homebrew/bin/brew ]; then \
		eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	elif [ -f /usr/local/bin/brew ]; then \
		eval "$$(/usr/local/bin/brew shellenv)"; \
	elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then \
		eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; \
	fi
endef

.PHONY: all vim zsh others reset fonts brew check_brew install_brew symlink vim_symlink zsh_symlink help

## Default - Interactive selection
all:
	@run_targets=$$(bash $(SCRIPTS_DIR)/interactive_menu.sh); \
	if [ -n "$$run_targets" ]; then \
		for target in $$run_targets; do \
			$(MAKE) $$target || exit 1; \
		done; \
	fi

## Install Vim + Neovim config
vim: fonts vim_symlink
	@$(SETUP_BREW); \
	bash $(SCRIPTS_DIR)/install_vim.sh

## Install Zsh + Zap config
zsh: fonts zsh_symlink
	@$(SETUP_BREW); \
	bash $(SCRIPTS_DIR)/install_zsh.sh

## Create Vim symlinks
vim_symlink:
	@source $(SCRIPTS_DIR)/install_methods.sh && \
		create_symlink ~/.vim/.vimrc ~/.vimrc && \
		create_symlink ~/.vim/.config/nvim ~/.config/nvim && \
		create_symlink ~/.vim/.config/mcphub ~/.config/mcphub

## Create Zsh symlinks
zsh_symlink:
	@source $(SCRIPTS_DIR)/install_methods.sh && \
		create_symlink ~/.vim/.zshrc ~/.zshrc && \
		create_symlink ~/.vim/.config/kitty ~/.config/kitty && \
		create_symlink ~/.vim/.config/lazygit ~/.config/lazygit && \
		create_symlink ~/.vim/.config/tmux ~/.config/tmux

## Install other tools (Docker, AWS CLI, etc.)
others:
	@bash $(SCRIPTS_DIR)/install_others.sh

reset:
	@echo "Cleaning symlinks..."
	@rm -f ~/.zshrc ~/.vimrc
	@rm -rf ~/.config/nvim ~/.config/tmux ~/.config/mcphub ~/.config/kitty ~/.config/lazygit

check_brew:
	@if ! command -v brew &> /dev/null; then \
		echo "Homebrew not found. Installing..."; \
		$(MAKE) install_brew; \
	else \
		if [ "$(VERBOSE)" = "1" ]; then \
			echo "Homebrew is already installed. Skipping installation."; \
		fi; \
	fi

install_brew:
	@echo "Installing Homebrew..."; \
	echo -n "Do you want to run in non-interactive mode? [y/N]: " > /dev/tty; \
	read -r answer < /dev/tty; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi; \
	echo "Configuring Homebrew in PATH..."; \
	if [ -f /opt/homebrew/bin/brew ]; then \
		eval "$$(/opt/homebrew/bin/brew shellenv)"; \
	elif [ -f /usr/local/bin/brew ]; then \
		eval "$$(/usr/local/bin/brew shellenv)"; \
	elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then \
		eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; \
	fi; \
	echo "Homebrew installed successfully!"

brew:
	@$(MAKE) check_brew VERBOSE=1

## Install fonts
fonts: check_brew
	@$(SETUP_BREW); \
	brew install --cask font-fira-code-nerd-font

symlink: vim_symlink zsh_symlink

help:
	@grep -E '^##' Makefile | sed -E 's/## //'
