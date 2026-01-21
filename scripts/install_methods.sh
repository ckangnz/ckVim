#!/bin/bash

# Trap signals for graceful exit (allows Ctrl+C to stop installation)
trap 'echo -e "\n${RED}Installation interrupted by user.${RESET}"; exit 130' INT TERM

# Define colors
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

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
	local packages=("$@")
	for package in "${packages[@]}"; do
		if brew ls "$package" &> /dev/null; then
			echo -e "${GREEN}FOUND:${RESET} ${package} is already installed!"
		else
			echo -e "${CYAN}INSTALL:${RESET} ${package}..."
			brew install "$package"
			echo -e "${GREEN}DONE:${RESET} ${package} is installed!"
		fi
	done
}

brew_install_cask() {
	if [[ ${machine} != Mac ]]; then
		echo -e "${YELLOW}WARNING:${RESET} Cask is not supported on ${machine}. Skipping installation."
		return
	fi

	local cask_packages=("$@")
	for cask in "${cask_packages[@]}"; do
		IFS=":" read -r cask_name tap <<< "$cask"

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
	done
}

create_symlink() {
	local target=$1
	local link_name=$2

	echo -e "${CYAN}Symlinking${RESET} ${YELLOW}$target${RESET} to ${YELLOW}$link_name${RESET} ..."

	if [ -e "$link_name" ]; then
		echo -e "${YELLOW}FOUND:${RESET}$link_name already exists!"
		echo -e "${CYAN}REMOVING:${RESET} existing $target..."
		rm -rf "$link_name"
	fi

	ln -s "$target" "$link_name"
	echo -e "${GREEN}Linked${RESET} $link_name successfully!"
	echo ""
}

