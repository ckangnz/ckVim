SHELL := /bin/bash
VIM_DIR := $(HOME)/.vim

.PHONY: all vim zsh others reset fonts symlink help

## Default
all: vim zsh others

## Install Vim + Neovim config
vim: fonts
	@source $(VIM_DIR)/install_methods.sh && \
	echo "Installing Vim/Neovim..." && \
	bash $(VIM_DIR)/install_vim.sh && \
	create_symlink ~/.vim/.vimrc ~/.vimrc && \
	create_symlink ~/.vim/.config/nvim ~/.config/nvim && \
	create_symlink ~/.vim/.config/mcphub ~/.config/mcphub

## Install Zsh + Zap config
zsh: fonts
	@source $(VIM_DIR)/install_methods.sh && \
	echo "Installing ZSH..." && \
	bash $(VIM_DIR)/install_zsh.sh && \
	create_symlink ~/.vim/.zshrc ~/.zshrc && \
	create_symlink ~/.vim/.config/tmux ~/.config/tmux

## Install other tools (Docker, AWS CLI, etc.)
others:
	@echo "Installing other software..."
	@bash $(VIM_DIR)/install_others.sh

## Remove symlinks and reset environment
reset:
	@echo "Cleaning symlinks..."
	@rm -f ~/.zshrc ~/.vimrc
	@rm -rf ~/.config/nvim ~/.config/tmux ~/.config/mcphub

fonts:
	@brew install --cask font-fira-code-nerd-font

symlink:
	@source $(VIM_DIR)/install_methods.sh && \
	create_symlink ~/.vim/.zshrc ~/.zshrc && \
	create_symlink ~/.vim/.vimrc ~/.vimrc && \
	create_symlink ~/.vim/.config/nvim ~/.config/nvim && \
	create_symlink ~/.vim/.config/mcphub ~/.config/mcphub && \
	create_symlink ~/.vim/.config/tmux ~/.config/tmux


## Show this help message
help:
	@grep -E '^##' Makefile | sed -E 's/## //'
