brew_install(){
    if brew ls $1 &> /dev/null; then
        echo "Detected ${1} is already installed!"
    else
        echo "Installing ${1}..."
        brew install $1
        echo "${1} is installed!"
    fi
}
brew_install_cask(){
    if brew ls --casks $1 &> /dev/null; then
        echo "Detected ${1} is already installed!"
    else
        echo "Installing ${1}..."
        if [ "$2" ]; then
            echo "Brew tapping to ${2}..."
            brew tap $2
        fi
        brew install $1 && echo '$1 is installed!'
    fi
}
npm_install(){
    if npm ls --versions $1 > /dev/null; then
        echo "${1} is already installed"
    else
        echo "Installing ${1}..."
        npm -g install $1 
        echo "${1} is installed!"
    fi
}
