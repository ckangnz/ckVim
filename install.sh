. ./install_methods.sh --source-only

echo "LET'S INSTALL CKVIM!!!!!!!"

brew_install "zsh"

brew_install "python3"
brew_install "node"
brew_install "oven-sh/bun/bun"
brew_install "fnm"

brew_install "nvim"
brew_install "vim"
brew_install "tmux"

brew_install "gh"
brew_install "bat"
brew_install "ripgrep"
brew_install "catimg"
brew_install "fzf"
brew_install "lsd"
brew_install "ctop" #docker tui

brew_install "awscli"
brew_install "kubectl"
brew_install "helm"
brew_install "tfenv" #terraform with version control
brew_install "hashicorp/tap/terraform-ls"

#[Check versions here](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)
brew_install_cask "dotnet-sdk"
#brew_install_cask "dotnet-sdk6-0-300" "isen-ng/dotnet-sdk-versions"

brew_install_cask "font-fira-code-nerd-font" "homebrew/cask-fonts"

#Symlink vimrc
if [ -e ~/.vimrc ]; then
    echo '.vimrc already exists! Deleting existing .vimrc...'
    rm ~/.vimrc
fi
echo 'Linking vimrc...'
ln -s ~/.vim/.vimrc ~/.vimrc
echo 'Completed Linking vimrc!'

#Symlink .config/nvim
if [ -d ~/.config/tmux ];then
  echo '.config/tmux already exists! Removing ~/.config/tmux directory'
  rm -rf ~/.config/tmux
else
  [ -d ~/.config ] && mkdir ~/.config
  echo 'Linking .config/tmux..'
  ln -s ~/.vim/.config/tmux ~/.config/tmux
  echo 'Completed Linking ./config/nvim!'
fi

#Symlink .config/nvim
if [ -d ~/.config/nvim ];then
  echo '.config/nvim already exists! Removing ~/.config/nvim directory'
  rm -rf ~/.config/nvim
else
  [ -d ~/.config ] && mkdir ~/.config
  echo 'Linking .config/nvim..'
  ln -s ~/.vim/.config/nvim ~/.config/nvim
  echo 'Completed Linking ./config/nvim!'
fi

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
