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
  "oven-sh/bun/bun"

  "nvim"
  "vim"

  "ripgrep"
  "catimg"
  "fzf"

  "font-fira-code-nerd-font"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

# Install Homebrew cask packages
cask_packages=(
  "dotnet-sdk"
)
echo "Installing brew cask packages..."
brew_install_cask "${cask_packages[@]}"
echo ""
echo ""

echo "Symlinking files..."
create_symlink ~/.vim/.vimrc ~/.vimrc
create_symlink ~/.vim/.config/nvim ~/.config/nvim
echo ""
echo ""
echo "         888      888     888 d8b              "
echo "         888      888     888 Y8P              "
echo "         888      888     888                  "
echo " .d8888b 888  888 Y88b   d88P 888 88888b..d88b."
echo "d88P    888 .88P   Y88b d88P  888 888  888 88b8"
echo "888      888888K    Y88o88P   888 888  888  888"
echo "Y88b.    888 88b     Y888P    888 888  888  888"
echo " Y88888P 888  888     Y8P     888 888  888  888 "
echo ""
echo ""
echo "Installation Completed!!"
