# CK VIM/ZSH

## Pre-requisite

Clone this project into `~/.vim`

```bash
git clone https://github.com/chris542/ckVim ~/.vim
```

# CK-Vim

_CK Vim supports NeoVim on all linux OS_

## You must have brew installed

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### On OSX

> :warning: This will override your .vimrc file

```bash
~/.vim/install.sh
```

### On WSL/Linux

There is no automatic installation script for Linux yet. Please copy and paste the following snippet to install all of the necessary libraries manually.

```bash
# You must install essential C Compilers
sudo apt-get update && sudo apt-get install build-essential

# Brew install other packages
brew install python3 node fnm nvim vim
brew install gh bat ripgrep
```

> :warning: This will override your .vimrc file

```bash
rm ~/.vimrc
ln -s ~/.vim/.vimrc ~/.vimrc
mkdir ~/.config
ln -s ~/.vim/.config/nvim ~/.config/nvim
```

### Install Plugins

1. Run vim
2. Run `:PlugInstall` or `,pi`

---

# CK-ZSH

## For MacOS

### Install Oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Zplug

```bash
brew install zplug
```

### Link .zshrc

> :warning: This will override your .zshrc file

```bash
#Synlink .zshrc
rm ~/.zshrc
ln -s ~/.vim/.zshrc ~/.zshrc
source ~/.zshrc
```

### Install plugins

```bash
zi
#or
zplug install
```

## For WSL/Linux

### Pre-requisite

#### Enabling Hyper V

1. Open "Turn Windows features on or off"
2. Find Hyper-V and enable it (This may require rebooting your comptuer)

#### Font Setup

- Manually download the FiraCode.zip from [here](https://github.com/ryanoasis/nerd-fonts/releases)
- Configure the Terminal configuration with the font

### Install ZSH

1. Open Terminal app and open WSL terminal
2. Install ZSH

```bash
sudo apt install zsh
```

3. Then run following command to change your default shell to ZSH

```bash
chsh -s $(which zsh)
```

### Install Oh-My-Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Zplug

```bash
brew install zplug
```

### Link .zshrc

> :warning: This will override your .zshrc file

```bash
#Synlink .zshrc
rm ~/.zshrc
ln -s ~/.vim/.zshrc ~/.zshrc
source ~/.zshrc
```

### Install plugins

```bash
zi
#or
zplug install
```

## Powerlevel10k Config

Run following command to configure your powerlevel10k theme.
Avoid sourcing `~/.p10k.zsh` as it is already imported in `.zshrc`

```bash
p10k configure
```

## Trouble-Shooting

- zsh compinit: insecure directories, run compaudit for list, run :

```bash
compaudit | xargs chmod g-w
```

- If you get a prompt that brew is missing after installation, simply run this command

```bash
eval "$(/usr/lib/bin/brew shellenv)"
```

- If you get a prompt that zplug is missing after installation, simply run this command

```bash
export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
source $ZPLUG_HOME/init.zsh
```

- If you get python issue on nvim install pynvim

```
$(which python3) -m pip install pynvim
```
