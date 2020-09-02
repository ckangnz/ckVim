filetype off                  " required

call plug#begin('~/.vim/plugged')

"Themes
Plug 'kristijanhusak/vim-hybrid-material'                 "Vim Syntax and UI Theme
Plug 'vim-airline/vim-airline'                            "Vim Airline
Plug 'vim-airline/vim-airline-themes'                     "Vim Airline Theme

"Syntax Highlighting
Plug 'tobyS/vmustache'                                    "Mustache Template syntax
Plug 'pangloss/vim-javascript'                            "JS syntax & indentation
Plug 'leafgarland/typescript-vim'                         "Typescript syntax
Plug 'peitalin/vim-jsx-typescript'                        "jsx syntax
Plug 'MaxMEllon/vim-jsx-pretty'                           "JSX Syntax
Plug 'nikvdp/ejs-syntax'                                  "EJS Syntax
Plug 'vim-python/python-syntax'                           "Python Syntax

"Git Tool
Plug 'idanarye/vim-merginal'                              "Git branch organiser
Plug 'junegunn/gv.vim'                                    "Git commit history browser
Plug 'tpope/vim-fugitive'                                 "Git on Vim
Plug 'tpope/vim-rhubarb'                                  "Github on Vim
Plug 'tyru/open-browser-github.vim'                       "Open Github URL
Plug 'tyru/open-browser.vim'                              "Open URL

"General IDE Tools
Plug 'Valloric/MatchTagAlways'                            "Highlights HTML tag pair
Plug 'arithran/vim-delete-hidden-buffers'                 "Delete Hidden Buffer
Plug 'godlygeek/tabular'                                  "Text Aligning Tool
Plug 'jiangmiao/auto-pairs'                               "Automatic closing ({['']})
Plug 'kristijanhusak/vim-carbon-now-sh'                   "Export to Carbon Now
Plug 'mattn/emmet-vim'                                    "Emmet
Plug 'scrooloose/nerdcommenter'                           "Easy Commenting tool
Plug 'tmhedberg/matchit'                                  "More functionality to %
Plug 'tpope/vim-surround'                                 "Easy text wrap tool
Plug 'tpope/vim-vinegar'                                  "Easy Netrw with '-'
Plug 'w0rp/ale'                                           "Liniting Engine

"General Vim Tool
Plug 'easymotion/vim-easymotion'                          "Easy Navigation
Plug 'gabrielelana/vim-markdown'                          "Easy MD tools
Plug 'mbbill/undotree'                                    "Magic of Undos
Plug 'skywind3000/asyncrun.vim'                           "Asyncrun tasks
Plug 'wesQ3/vim-windowswap'                               "Split Panel switch

"Search Tool
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                   "Fuzzy find files/content/tags
Plug 'skwp/greplace.vim'                                  "Project search and replace

"Autofill
Plug 'ervandew/supertab'                                  "Use autocompleted text with tab
Plug 'Valloric/YouCompleteMe', { 'do' : './install.py --ts-completer' }

"Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'       "Snippet Library

call plug#end()
