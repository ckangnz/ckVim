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

### YCM Install
* If you see YCM error on vim startup, follow this :
```bash
cd ~/.vim/bundle/YouCompleteMe
./install.py
```

## Zsh Terminal Theme .zshrc
Install powerline
```bash
#Copy Paste below
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

#Install fonts
...
...

#Synlink .zshrc
ln -s ~/.vim/.zshrc ~/.zshrc
```
