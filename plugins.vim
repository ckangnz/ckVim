filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'                               "Plugin Installer
Plugin 'tpope/vim-vinegar'                                  "Easy Netrw with '-'

"Themes
Plugin 'kristijanhusak/vim-hybrid-material'                 "Vim Syntax and UI Theme
Plugin 'vim-airline/vim-airline'                            "Vim Airline
Plugin 'vim-airline/vim-airline-themes'                     "Vim Airline Theme

"Syntax Highlighting
Plugin 'tobyS/vmustache'                                    "Mustache Template syntax
Plugin 'pangloss/vim-javascript'                            "JS syntax & indentation
Plugin 'MaxMEllon/vim-jsx-pretty'                           "JSX Syntax
Plugin 'nikvdp/ejs-syntax'                                  "EJS Syntax
Plugin 'vim-python/python-syntax'                           "Python Syntax

"Git Tool
Plugin 'tpope/vim-fugitive'                                 "Git on Vim
Plugin 'idanarye/vim-merginal'                              "Git branch organiser
Plugin 'junegunn/gv.vim'                                    "Git commit history browser

"General IDE Tools
Plugin 'Valloric/MatchTagAlways'                            "Highlights HTML tag pair
Plugin 'arithran/vim-delete-hidden-buffers'                 "Delete Hidden Buffer
Plugin 'ctrlpvim/ctrlp.vim'                                 "Project Tree browser
Plugin 'godlygeek/tabular'                                  "Text Aligning Tool
Plugin 'jiangmiao/auto-pairs'                               "Automatic closing ({['']})
Plugin 'kristijanhusak/vim-carbon-now-sh'                   "Export to Carbon Now
Plugin 'mattn/emmet-vim'                                    "Emmet
Plugin 'nathanaelkane/vim-indent-guides'                    "Indentation Guide (,ig)
Plugin 'scrooloose/nerdcommenter'                           "Easy Commenting tool
Plugin 'tmhedberg/matchit'                                  "More functionality to %
Plugin 'tpope/vim-surround'                                 "Easy text wrap tool

"General Vim Tool
Plugin 'gabrielelana/vim-markdown'                          "Easy MD tools
Plugin 'mbbill/undotree'                                    "Magic of Undos
Plugin 'skywind3000/asyncrun.vim'                           "Asyncrun tasks
Plugin 'wesQ3/vim-windowswap'                               "Split Panel switch

"Search Tool
Plugin 'mileszs/ack.vim'                                    "Project search
Plugin 'skwp/greplace.vim'                                  "Project search and replace

"Autofill (YCM requires macvim : run install.py --all in bundle/ycm folder)
Plugin 'Valloric/YouCompleteMe'                             "Autofill Tool
Plugin 'ervandew/supertab'                                  "Use autocompleted text with tab

"Snippets
Plugin 'SirVer/ultisnips'                                   "Snippet Tool
Plugin 'honza/vim-snippets'                                 "Snippet Library

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
