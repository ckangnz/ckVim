#Install Macvim
if brew ls --versions macvim > /dev/null; then
    echo 'Detected existing Macvim'
else
    echo 'Installing Macvim...'
    brew install macvim --with-override-system-vim
    echo 'Completed Installing Macvim!'
fi

#Install FZF
if brew ls --versions fzf > /dev/null; then
    echo 'Detected existing fzf'
else
    echo 'Installing fzf...'
    brew install fzf
    $(brew --prefix)/opt/fzf/install
    echo 'Completed Installing fzf!'
fi

#Install Universal Ctags
if brew ls --versions universal-ctags > /dev/null; then
    echo 'Detected ctags'
else
    echo 'Installing Ctags...'
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    echo 'Completed Installing Ctags!'
fi

#Install The Silver Searcher
if brew ls --versions the_silver_searcher > /dev/null; then
    echo 'Detected the_silver searcher'
else
    echo 'Installing the_silver_searcher...'
    brew install --HEAD the_silver_searcher
    echo 'Completed Installing the_silver_searcher!'
fi

#Install Ack
if brew ls --versions ack > /dev/null; then
    echo 'Detected ack'
else
    echo 'Installing Ack...'
    brew install --HEAD the_silver_searcher
    echo 'Completed Installing Ack!'
fi

#Install Instant Markdown
if npm ls --versions instant-markdown-d > /dev/null; then
    echo 'Instant-Markdown already exists'
else
    echo 'Installing Markdown...'
    npm -g install instant-markdown-d
    echo 'Completed Installing Markdown!'
fi

#Install Vundle then plugins
if [! -e ~/.vim/bundle/Vundle.vim ]; then
    echo 'Installing Vundle...'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo 'Completed Installing Vundle'
fi
echo 'Installing all vim plugins...'
vim -c 'PluginInstall' -c 'qa!'
echo 'Completed installing all vim plugins'

#Symlink vimrc
if [ -e ~/.vimrc ]; then
    echo '.vimrc already exists! Deleting existing .vimrc...'
    rm ~/.vimrc
fi
echo 'Linking vimrc...'
ln -s ~/.vim/.vimrc ~/.vimrc
echo 'Completed Linking vimrc!'

#Symlink ctags
echo 'Linking ctag config...'
ln -s ~/.vim/.ctags.d ~/.ctags.d
echo 'Completed Linking ctag config!'

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
echo "Installation Completed"
