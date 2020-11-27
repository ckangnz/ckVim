#Install python3
if brew ls --versions python3 > /dev/null; then
    echo 'Detected existing Python3'
else
    echo 'Installing Python3...'
    brew install python3
    echo 'Completed Installing Python3!'
fi

#Install vim
echo 'Installing vim...'
brew install macvim --with-override-system-vim
echo 'Completed Installing vim!'

#Install Macvim
if brew ls --versions macvim > /dev/null; then
    echo 'Detected existing Macvim'
else
    echo 'Installing Macvim...'
    brew install macvim
    echo 'Completed Installing Macvim!'
fi

#Install Universal Ctags
if brew ls --versions universal-ctags > /dev/null; then
    echo 'Detected ctags'
else
    echo 'Installing Ctags...'
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    echo 'Completed Installing Ctags!'
fi

#Install The cmake
if brew ls --versions cmake > /dev/null; then
    echo 'Detected cmake'
else
    echo 'Installing cmake...'
    brew install --HEAD cmake
    echo 'Completed Installing cmake!'
fi

#Install bat
if brew ls --versions bat > /dev/null; then
    echo 'Detected bat'
else
    echo 'Installing bat...'
    brew install --HEAD bat
    echo 'Completed Installing bat!'
fi

#Install The Silver Searcher (Ag)
if brew ls --versions the_silver_searcher > /dev/null; then
    echo 'Detected the_silver_searcher'
else
    echo 'Installing the_silver_searcher...'
    brew install --HEAD the_silver_searcher
    echo 'Completed Installing the_silver_searcher!'
fi

#Install Ripgrep 
if brew ls --versions ripgrep > /dev/null; then
    echo 'Detected ripgrep'
else
    echo 'Installing ripgrep...'
    brew install --HEAD ripgrep
    echo 'Completed Installing Ripgrep!'
fi

#Install Instant Markdown
if npm ls --versions instant-markdown-d > /dev/null; then
    echo 'Instant-Markdown already exists'
else
    echo 'Installing Markdown...'
    npm -g install instant-markdown-d
    echo 'Completed Installing Markdown!'
fi

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
