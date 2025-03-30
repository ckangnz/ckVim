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
  "oven-sh/bun/bun"
  "fnm"

  "gh"
  "bat"
  "ripgrep"
  "fzf"
  "lsd"
)
echo "Installing brew packages..."
brew_install "${packages[@]}"
echo ""
echo ""

echo "Installing ZAP"
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 -k
echo ""
echo ""

# Install Homebrew cask packages
cask_packages=(
  "font-fira-code-nerd-font"
)
echo "Installing brew cask packages..."
brew_install_cask "${cask_packages[@]}"
echo ""
echo ""

echo "Symlinking files..."
create_symlink ~/.vim/.zshrc ~/.zshrc
create_symlink ~/.vim/.config/tmux ~/.config/tmux
echo ""
echo ""

if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
else
  echo "Default shell is already zsh."
fi
echo ""
echo ""

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
