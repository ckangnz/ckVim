#!/bin/bash

# Load install methods
. ./install_methods.sh --source-only

echo "LET'S INSTALL CKZSH!!!!!!!"
echo ""

# Ensure ~/.config exists
[ -d ~/.config ] || mkdir -p ~/.config

# Install Homebrew packages
packages=(
	"zsh"
	"tmux"

	"python3"
	"node"
	"fnm"
	"uv"

	"gh"
	"bat"

	"fd"
	"ripgrep"
	"fzf"

	"lsd"

	"jannis-baum/tap/vivify"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

echo "Installing ZAP"
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k
echo ""
echo ""

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
	echo "Changing default shell to zsh..."
	chsh -s "$(which zsh)"
else
	echo "Default shell is already zsh."
fi

echo "."
echo "."
echo " ██████╗██╗  ██╗███████╗███████╗██╗  ██╗"
echo "██╔════╝██║ ██╔╝╚══███╔╝██╔════╝██║  ██║"
echo "██║     █████╔╝   ███╔╝ ███████╗███████║"
echo "██║     ██╔═██╗  ███╔╝  ╚════██║██╔══██║"
echo "╚██████╗██║  ██╗███████╗███████║██║  ██║"
echo " ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
echo "."
echo "."
echo "Installation Completed!!"
