#Install Macvim
if brew ls --versions macvim > /dev/null; then
    echo 'Detected existing Macvim. Uninstalling current version--------'
    brew uninstall macvim
fi
echo 'Installing Macvim--------'
brew install macvim --with-override-system-vim

#Install Vundle
if [! -e ~/.vim/bundle/Vundle.vim ]; then
    echo 'Installing Vundle--------'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#Install all plugins
echo 'Installing Vim Plugins--------'
vim -c 'PluginInstall' -c 'qa!'

#Symlink vimrc
if [ -e ~/.vimrc ]; then
    echo 'vimrc already exists. Deleting existing .vimrc--------'
    rm ~/.vimrc
fi
echo 'Linking vimrc--------'
ln -s ~/.vim/.vimrc ~/.vimrc

#Install Instant Markdown
if npm ls --versions instant-markdown-d > /dev/null; then
    echo 'Instant-Markdown already exists'
else
    echo 'Installing Markdown--------'
    npm -g install instant-markdown-d
fi


echo("         888      888     888 d8b              ")
echo("         888      888     888 Y8P              ")
echo("         888      888     888                  ")
echo(" .d8888b 888  888 Y88b   d88P 888 88888b..d88b. ")
echo("d88P    888 .88P   Y88b d88P  888 888  888 88b8")
echo("888      888888K    Y88o88P   888 888  888  888")
echo("Y88b.    888 88b    Y8888P    888 888  888  888")
echo(" Y8888P 888  888     Y8P     888 888  888  888 ........ is now installed!")
