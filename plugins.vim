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

Plugin 'Townk/vim-autoclose'                                "Automatic closing ({['']})
Plugin 'Valloric/MatchTagAlways'                            "Highlights HTML tag pair
Plugin 'arithran/vim-delete-hidden-buffers'                 "Delete Hidden Buffer
Plugin 'ctrlpvim/ctrlp.vim'                                 "Project Tree browser
Plugin 'gabrielelana/vim-markdown'                          "Easy MD tools
Plugin 'godlygeek/tabular'                                  "Text Aligning Tool
Plugin 'mattn/emmet-vim'                                    "Emmet
Plugin 'nathanaelkane/vim-indent-guides'                    "Indentation Guide (,ig)
Plugin 'scrooloose/nerdcommenter'                           "Easy Commenting tool
Plugin 'skywind3000/asyncrun.vim'                           "Asyncrun tasks
Plugin 'tmhedberg/matchit'                                  "More functionality to %
Plugin 'tpope/vim-surround'                                 "Easy text wrap tool
Plugin 'wesQ3/vim-windowswap'                               "Split Panel switch

" These plugins need the_silver_searcher. Install with homebrew
Plugin 'mileszs/ack.vim'                                    "Project search
Plugin 'skwp/greplace.vim'                                  "Project search and replace

"Autofill (YCM needs brew install)
Plugin 'Valloric/YouCompleteMe'                             "Autofill Tool
Plugin 'garbas/vim-snipmate'                                "Previews automatic fill
Plugin 'ervandew/supertab'                                  "Automatic Fill detection
Plugin 'honza/vim-snippets'                                 "Snippet Library
Plugin 'SirVer/ultisnips'                                   "Snippet Tool

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
