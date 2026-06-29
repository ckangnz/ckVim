SHELL := /bin/bash
VIM_DIR := $(HOME)/.vim
SCRIPTS_DIR := $(VIM_DIR)/scripts

.PHONY: all vim zsh others reset fonts brew check_brew install_brew symlink vim_symlink zsh_symlink agent_hooks agents help gitignore

all: ## Interactive installation menu
	@run_targets=$$(bash $(SCRIPTS_DIR)/interactive_menu.sh); \
	if [ -n "$$run_targets" ]; then \
		for target in $$run_targets; do \
			$(MAKE) $$target || exit 1; \
		done; \
	fi

vim: check_brew gitignore vim_symlink ## Install Vim/Neovim config + packages
	@bash $(SCRIPTS_DIR)/install_vim.sh

zsh: check_brew gitignore zsh_symlink agent_hooks agents ## Install Zsh config + packages + agent hooks
	@bash $(SCRIPTS_DIR)/install_zsh.sh

agent_hooks: ## Install tmux AI-agent status hooks
	@bash $(VIM_DIR)/.config/tmux/scripts/install-agent-hooks.sh

agents: ## Symlink AGENTS.md into Claude Code + Codex
	@mkdir -p ~/.claude ~/.codex
	@source $(SCRIPTS_DIR)/install_methods.sh && \
		create_symlink ~/.vim/AGENTS.md ~/.claude/CLAUDE.md && \
		create_symlink ~/.vim/AGENTS.md ~/.codex/AGENTS.md

vim_symlink: ## Symlink Vim/Neovim config only
	@source $(SCRIPTS_DIR)/install_methods.sh && \
		create_symlink ~/.vim/.vimrc ~/.vimrc && \
		create_symlink ~/.vim/.config/nvim ~/.config/nvim && \
		create_symlink ~/.vim/.config/mcphub ~/.config/mcphub

zsh_symlink: ## Symlink Zsh/tmux/kitty/lazygit config only
	@source $(SCRIPTS_DIR)/install_methods.sh && \
		create_symlink ~/.vim/.zshrc ~/.zshrc && \
		create_symlink ~/.vim/.config/kitty ~/.config/kitty && \
		create_symlink ~/.vim/.config/lazygit ~/.config/lazygit && \
		create_symlink ~/.vim/.config/tmux ~/.config/tmux

others: ## Install additional tools (macOS)
	@bash $(SCRIPTS_DIR)/install_others.sh

reset: ## Remove all symlinks
	@echo "Cleaning symlinks..."
	@rm -f ~/.zshrc ~/.vimrc
	@rm -rf ~/.config/nvim ~/.config/tmux ~/.config/mcphub ~/.config/kitty ~/.config/lazygit

check_brew:
	@if ! command -v brew &> /dev/null; then \
		echo ""; \
		echo "❌ Error: Homebrew is not installed or not in PATH!"; \
		echo ""; \
		echo "Please either:"; \
		echo "  1. Run 'make brew' to install Homebrew, then follow the eval instructions"; \
		echo "  2. If already installed, run the eval command for your system:"; \
		echo ""; \
		if [ -f /opt/homebrew/bin/brew ]; then \
			echo "     eval \"\$$(/opt/homebrew/bin/brew shellenv)\""; \
		elif [ -f /usr/local/bin/brew ]; then \
			echo "     eval \"\$$(/usr/local/bin/brew shellenv)\""; \
		elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then \
			echo "     eval \"\$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""; \
		fi; \
		echo ""; \
		exit 1; \
	fi

install_brew:
	@echo "Installing Homebrew..."; \
	NONINTERACTIVE=1 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	echo ""; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo "✅ Homebrew installed successfully!"; \
	echo ""; \
	echo "⚠️  IMPORTANT: Add Homebrew to your PATH by running:"; \
	echo ""; \
	if [ -f /opt/homebrew/bin/brew ]; then \
		echo "   eval \"\$$(/opt/homebrew/bin/brew shellenv)\""; \
	elif [ -f /usr/local/bin/brew ]; then \
		echo "   eval \"\$$(/usr/local/bin/brew shellenv)\""; \
	elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then \
		echo "   eval \"\$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""; \
	fi; \
	echo ""; \
	echo "Or restart your terminal, then run 'make all' again."; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo ""

brew: install_brew ## Install Homebrew

fonts: check_brew ## Install FiraCode Nerd Font
	@brew install --cask font-fira-code-nerd-font

symlink: vim_symlink zsh_symlink ## Create all symlinks (vim + zsh)

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-13s\033[0m %s\n", $$1, $$2}'

gitignore: ## Add ck_* to global gitignore + set excludesfile
	@GLOBAL_GITIGNORE="$$HOME/.gitignore"; \
	if ! grep -qx "ck_\*" "$$GLOBAL_GITIGNORE" 2>/dev/null; then \
		echo "ck_*" >> "$$GLOBAL_GITIGNORE"; \
		echo "✓ Added ck_* to ~/.gitignore"; \
	else \
		echo "ℹ ck_* already in ~/.gitignore — skipping"; \
	fi; \
	git config --global core.excludesfile "$$GLOBAL_GITIGNORE"; \
	echo "✓ Set git core.excludesfile to ~/.gitignore"
