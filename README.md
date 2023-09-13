[toc]

# CK-Vim

## Pre-requisite

Clone this project into `~/.vim`

```bash
git clone https://github.com/chris542/ckVim ~/.vim
```

_CK Vim supports NeoVim on all linux environment_

## :house: Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## :apple: Install CKVim on OSX

> :warning: This will override your .vimrc file

```bash
~/.vim/install.sh
```

## :penguin: Install CKVim on WSL/Linux

There is no automatic installation script for Linux yet. Please copy and paste the following snippet to install all of the necessary libraries manually.

```bash
# You must install essential C Compilers
sudo apt-get update && sudo apt-get install build-essential

# Install dotnet6 or dotnet7
sudo apt update && sudo apt install dotnet7

# Brew install other packages
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"]
brew install python3 node fnm nvim vim
brew install gh bat ripgrep catimg fzf
```

> :warning: This will override your .vimrc file

```bash
rm ~/.vimrc
ln -s ~/.vim/.vimrc ~/.vimrc
mkdir ~/.config
ln -s ~/.vim/.config/nvim ~/.config/nvim
```

## :gear: Install Plugins

1. Run vim
2. Run `:PlugInstall` or `,pi`

---

# CK-ZSH

## :apple: For MacOS

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

## :penguin: For WSL/Linux

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

## Configure your Powerlevel10k

Run following command to configure your powerlevel10k theme.
Avoid sourcing `~/.p10k.zsh` as it is already imported in `.zshrc`

```bash
#alias p10
p10k configure
```

## Trouble-Shooting

- zsh compinit: insecure directories, run compaudit for list, run :

```bash
compaudit | xargs chmod g-w
```

- If you get a prompt that brew is missing after installation, simply run this command

```bash
# For Mac
eval "$(/usr/lib/bin/brew shellenv)"

# For Linux
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"]
```

- If you get a prompt that zplug is missing after installation, simply run this command

```bash
export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
source $ZPLUG_HOME/init.zsh
```

- If you get python issue on nvim install pynvim

```bash
$(which python3) -m pip install pynvim
```

- Update csharp_ls time to time

```bash
dotnet tool update -g csharp-ls
```

- If you get fnm Error 13 permission denied

```bash
sudo chown -R $(whoami) /run/user/1000/
```
