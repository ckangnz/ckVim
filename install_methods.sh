# Define colors
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"  # Reset color

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

brew_install() {
    if brew ls "$1" &> /dev/null; then
        echo -e "${GREEN}FOUND:${RESET} ${1} is already installed!"
    else
        echo -e "${CYAN}INSTALL:${RESET} ${1}..."
        if [ "$2" ]; then
            echo -e "${CYAN}TAP:${RESET} Brew tapping to ${2}..."
            brew tap "$2"
        fi
        brew install "$1"
        echo -e "${GREEN}DONE:${RESET} ${1} is installed!"
    fi
}

brew_install_cask() {
  if [[ ${machine} != Mac ]]; then
    echo -e "${YELLOW}WARNING:${RESET} Cask is not supported on ${machine}. Couldn't install $1."
    return
  fi

  IFS=":" read -r cask_name tap <<< "$1"

  if brew list --cask | grep -q "^${cask_name}$"; then
    echo -e "${GREEN}FOUND:${RESET} ${cask_name} is already installed!"
  else
    echo -e "${CYAN}INSTALL:${RESET} ${cask_name}..."
    if [[ -n "$tap" ]]; then
      echo -e "${CYAN}TAP:${RESET} Brew tapping into ${tap}..."
      brew tap "$tap"
    fi
    brew install --cask "$cask_name"
    echo -e "${GREEN}DONE:${RESET} ${cask_name} is installed!"
  fi
}

create_symlink() {
  local target=$1
  local link_name=$2

  echo -e "${CYAN}Symlinking${RESET} $target to $link_name ..."

  if [ -e "$link_name" ]; then
    echo -e "${YELLOW}FOUND:${RESET}$link_name already exists!"
    echo "${CYAN}REMOVING:${RESET} existing $target..."
    rm -rf "$link_name"
  fi

  ln -s "$target" "$link_name"
  echo -e "${GREEN}Linked${RESET} $link_name successfully!"
}

