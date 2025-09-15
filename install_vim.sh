#!/bin/bash

# Load install methods
. ./install_methods.sh --source-only

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
  "ripgrep"
  "catimg"
  "fzf"

  "jannis-baum/tap/vivify"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
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
