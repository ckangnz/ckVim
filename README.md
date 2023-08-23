# CK Vim Config

##### _CK Vim supports NeoVim(OSX) and Vim(OSX/Linux/WSL)_

### You must have brew installed

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

#### Run this to install everything automatically :)

#### Clone this project into `~/.vim`

```bash
git clone https://github.com/chris542/ckVim ~/.vim
```

##### On OSX

> :warning: This will override your .vimrc file

```bash
~/.vim/install.sh
```

##### On WSL/Linux

```bash
brew install python3 node fnm vim
brew install cmake bat watchman the_silver_searcher ripgrep

rm ~/.vimrc
ln -s ~/.vim/.vimrc ~/.vimrc
ln -s ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
```

## OSX Guide to Setup ZSH

### Pre-requisite

#### Install zplug

```bash
brew install zplug
```

#### Install Oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Link .zshrc

> :warning: This will override your .zshrc file

```bash
#Synlink .zshrc
rm ~/.zshrc
ln -s ~/.vim/.zshrc ~/.zshrc
```

### Install plugins

```bash
zi
#or
zplug install
```

## WSL/Linux Guide to Setup ZSH

### Pre-requisite

#### Enabling Hyper V

1. Open "Turn Windows features on or off"
2. Find Hyper-V and enable it (This may require rebooting your comptuer)

#### Font Setup

- Manually download the FiraCode.zip from [here](https://github.com/ryanoasis/nerd-fonts/releases)
- Configure the Terminal configuration with the font

### Install ZSH on WSL

1. Open Terminal app and open WSL terminal
2. Install ZSH

```bash
sudo apt install zsh

# Use zsh as default
chsh -s $(which zsh)
```

3. Use ZSH as default on WSL

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
```

### Install plugins

```bash
zi
#or
zplug install

# zi kubectl helm
```

## Trouble-Shooting

- zsh compinit: insecure directories, run compaudit for list, run :

```bash
compaudit | xargs chmod g-w
```
