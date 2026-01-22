#!/bin/bash

# Load install methods
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/install_methods.sh" --source-only

echo "LET'S INSTALL CKNVIM!!!!!!!"
echo ""

# Ensure ~/.config exists
[ -d ~/.config ] || mkdir -p ~/.config

# Install Homebrew packages
packages=(
	"python3"
	"node"

	"nvim"
	"vim"

	"uv"
	"fd"
	"ripgrep"
	"fzf"
	"catimg"

	"jannis-baum/tap/vivify"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

echo "Installing pynvim for Neovim..."
python3 -m pip install --user --break-system-packages pynvim 2>/dev/null || python3 -m pip install --user pynvim
echo ""
echo ""

echo " ██████╗██╗  ██╗██╗   ██╗██╗███╗   ███╗",
echo "██╔════╝██║ ██╔╝██║   ██║██║████╗ ████║",
echo "██║     █████╔╝ ██║   ██║██║██╔████╔██║",
echo "██║     ██╔═██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║",
echo "╚██████╗██║  ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║",
echo " ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
echo ""
echo ""
echo "Installation Completed!!"
