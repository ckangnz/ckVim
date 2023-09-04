. ./install_methods.sh --source-only

echo "LET'S INSTALL CKVIM!!!!!!!"

brew_install "python3"
brew_install "node"
brew_install "fnm"

brew_install "nvim"
brew_install "vim"
brew_install_cask "neovide"

brew_install "gh"
brew_install "bat"
brew_install "ripgrep"

#[Check versions here](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)
brew_install_cask "dotnet-sdk"
#brew_install_cask "dotnet-sdk6-0-300" "isen-ng/dotnet-sdk-versions"

brew_install_cask "font-fira-code-nerd-font" "homebrew/cask-fonts"

#Install pynvim for Neovim
$(which python3) -m pip install pynvim

#Symlink vimrc
if [ -e ~/.vimrc ]; then
    echo '.vimrc already exists! Deleting existing .vimrc...'
    rm ~/.vimrc
fi
echo 'Linking vimrc...'
ln -s ~/.vim/.vimrc ~/.vimrc
echo 'Completed Linking vimrc!'

if [ ! -d ~/.config/nvim ];then
  echo 'Creating ~/.config/nvim directory'
  mkdir ~/.config/nvim
fi

#Symlink init.lua
if [ -e ~/.config/nvim/init.lua ]; then
    echo 'init.lua already exists! Deleting existing init.lua...'
    rm ~/.config/nvim/init.lua
fi
echo 'Linking init.lua..'
ln -s ~/.vim/extra_vim_config/init.lua ~/.config/nvim/init.lua
echo 'Completed Linking init.lua for nvim!'

#Symlink coc-settings.json
if[ -e ~/.config/nvim/coc-settings.json ]; then
  echo 'coc-settings.json already exists! Deleting existing coc-settings.json'
  rm ~/.config/nvim/coc-settings.json
fi
echo 'Linking coc-settings...'
ln -s ~/.vim/extra_vim_config/coc-settings.json ~/.config/nvim/coc-settings.json
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
