# CK Vim Config

## You must have brew installed
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Copy / Paste this into your terminal and DONE :)
```bash
git clone https://github.com/chris542/ckVim ~/.vim
~/.vim/install.sh
```

 WARNING: This will override your .vimrc file

## For .zshrc
Install powerline
```bash
#Copy Paste below
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

#Copy Paste below
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
```

### If you have trouble seeing some fonts follow this guide
https://github.com/gabrielelana/awesome-terminal-fonts/wiki/OS-X 


---

### Plugins used

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'tpope/vim-vinegar'
    Plugin 'kristijanhusak/vim-hybrid-material'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'skywind3000/asyncrun.vim'
    Plugin 'tpope/vim-fugitive'
    Plugin 'idanarye/vim-merginal'
    Plugin 'junegunn/gv.vim'
    Plugin 'wesQ3/vim-windowswap'
    Plugin 'nathanaelkane/vim-indent-guides'
    Plugin 'godlygeek/tabular'
    Plugin 'Valloric/MatchTagAlways'
    Plugin 'tmhedberg/matchit'
    Plugin 'jiangmiao/auto-pairs'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'mileszs/ack.vim'
    Plugin 'skwp/greplace.vim'
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'garbas/vim-snipmate'
    Plugin 'tpope/vim-surround'
    Plugin 'tobyS/vmustache'
    Plugin 'mattn/emmet-vim'
    Plugin 'Townk/vim-autoclose'
    Plugin 'pangloss/vim-javascript'
    Plugin 'MaxMEllon/vim-jsx-pretty'
    Plugin 'gabrielelana/vim-markdown'
    Plugin 'nikvdp/ejs-syntax'
    Plugin 'vim-python/python-syntax'
    Plugin 'mgedmin/python-imports.vim'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'ervandew/supertab'
    Plugin 'SirVer/ultisnips'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'honza/vim-snippets'
    Plugin 'arithran/vim-delete-hidden-buffers'
