# CK Vim Config

##### _CK Vim uses MacVim, and requires OSX_
### You must have brew installed

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
---

#### Run this to install everything automatically :)

```bash
git clone https://github.com/chris542/ckVim ~/.vim
~/.vim/install.sh
```
##### WARNING: This will override your .vimrc file

## Zsh Terminal Theme .zshrc
### Install Fira font
```bash
brew tap homebrew/cask-fonts
brew cask install font-fira-code-nerd-font
```
### Install Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
### Install zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
### Install zsh-syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Link zshrc
```bash
#Synlink .zshrc
ln -s ~/.vim/.zshrc ~/.zshrc
```
