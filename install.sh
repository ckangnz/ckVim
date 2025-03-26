#!/bin/bash

# Load install methods
. ./install_methods.sh --source-only

echo "LET'S INSTALL CKNVIM!!!!!!!"
echo ""

# Ensure ~/.config exists
[ -d ~/.config ] || mkdir -p ~/.config

# Install Homebrew packages
packages=(
  "zsh"

  "python3"
  "node"
  "oven-sh/bun/bun"
  "fnm"

  "nvim"
  "vim"
  "tmux"

  "gh"
  "bat"
  "ripgrep"
  "catimg"
  "fzf"
  "lsd"

  "ducker"
  "awscli"
  "kubectl"
  "k9s"
  "helm"
  "tfenv" # Terraform with version control
  "hashicorp/tap/terraform-ls"
)
echo "Installing brew packages..."
for package in "${packages[@]}"; do
  brew_install "$package"
done
echo ""
echo ""

# Install Homebrew cask packages
cask_packages=(
  "dotnet-sdk"
  "font-fira-code-nerd-font:homebrew/cask-fonts"
)
echo "Installing brew cask packages..."
for cask in "${cask_packages[@]}"; do
  brew_install_cask "$cask"
done
echo ""
echo ""

echo "Symlinking files..."
create_symlink ~/.vim/.vimrc ~/.vimrc
create_symlink ~/.vim/.config/tmux ~/.config/tmux
create_symlink ~/.vim/.config/nvim ~/.config/nvim
echo ""
echo ""

echo "."
echo "."
echo "."
echo "         888      888     888 d8b              "
echo "         888      888     888 Y8P              "
echo "         888      888     888                  "
echo " .d8888b 888  888 Y88b   d88P 888 88888b..d88b."
echo "d88P    888 .88P   Y88b d88P  888 888  888 88b8"
echo "888      888888K    Y88o88P   888 888  888  888"
echo "Y88b.    888 88b     Y888P    888 888  888  888"
echo " Y88888P 888  888     Y8P     888 888  888  888 "
echo "."
echo "."
echo "Installation Completed!!"
