. ./install_methods.sh --source-only

echo "LET'S INSTALL CKVIM!!!!!!!"

brew_install "python3"
brew_install "node"
brew_install "fnm"
brew_install "macvim"
brew_install "nvim"
brew_install_cask "neovide"
brew_install "cmake"
brew_install "bat"
brew_install "watchman"
brew_install "the_silver_searcher"
brew_install "ripgrep"

#[Check versions here](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)
brew_install_cask "dotnet-sdk"
brew_install_cask "dotnet-sdk6-0-300" "isen-ng/dotnet-sdk-versions"

brew_install_cask "font-fira-code-nerd-font" "homebrew/cask-fonts"

#Symlink vimrc
if [ -e ~/.vimrc ]; then
    echo '.vimrc already exists! Deleting existing .vimrc...'
    rm ~/.vimrc
fi
echo 'Linking vimrc...'
ln -s ~/.vim/.vimrc ~/.vimrc
echo 'Completed Linking vimrc!'

#Symlink init.vim
if [ -e ~/.config/nvim/init.vim ]; then
    echo '.vimrc already exists! Deleting existing .vimrc...'
    rm ~/.config/nvim/init.vim
fi
echo 'Linking vimrc...'
ln -s ~/.vim/init.vim ~/.config/nvim/init.vim
echo 'Completed Linking init.vim for nvim!'

if[ -e ~/.config/nvim/coc-settings.json ]; then
  echo 'coc-settings.json already exists! Deleting existing coc-settings.json'
  rm ~/.config/nvim/coc-settings.json
fi
echo 'Linking coc-settings...'
ln -s ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
echo 'Completed Linking coc-settings.json for nvim!'

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
