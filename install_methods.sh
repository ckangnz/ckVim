unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

brew_install(){
    if brew ls $1 &> /dev/null; then
        echo "FOUND: ${1} is already installed!"
    else
        echo "INSTALL: ${1}..."
        if [ "$2" ]; then
            echo "TAP: Brew tapping to ${2}..."
            brew tap $2
        fi
        brew install $1
        echo "DONE: ${1} is installed!"
    fi
}

brew_install_cask(){
  if [[ ${machine} == Mac ]]; then
    if brew ls --casks $1 &> /dev/null; then
        echo "FOUND: ${1} is already installed!"
    else
        echo "INSTALL: ${1}..."
        if [ "$2" ]; then
            echo "TAP: Brew tapping to ${2}..."
            brew tap $2
        fi
        brew install --cask $1
        echo 'DONE: $1 is installed!'
    fi
  else
    echo "WARNING: Cask is not supported in ${machine}. Couldn't install $1."
  fi
}

npm_install(){
    if npm ls --versions $1 > /dev/null; then
        echo "NPM FOUND: ${1} is already installed"
    else
        echo "NPM INSTALL: Installing ${1}..."
        npm -g install $1
        echo "NPM DONE: ${1} is installed!"
    fi
}
