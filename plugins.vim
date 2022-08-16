filetype off                                                        " required

call plug#begin('~/.vim/plugged')


" VIM GUI
Plug 'sainnhe/gruvbox-material'
Plug 'vim-airline/vim-airline'                                      " Vim Airline
Plug 'skywind3000/vim-quickui'                                      " Context Quick UI
Plug 'tpope/vim-vinegar'                                            " Easy Netrw with '-'
Plug 'dstein64/vim-startuptime'                                     " Show :StartupTime
Plug 'junegunn/goyo.vim'                                            " Silence view
Plug 'markonm/traces.vim'                                           " Preview highlights and substitute
Plug 'mbbill/undotree'                                              " Magic of Undos
Plug 'miyakogi/conoline.vim'                                        " Highlight current line

" Language Specific
Plug 'briancollins/vim-jst'                                         " .ejs
Plug 'gabrielelana/vim-markdown'                                    " .md
Plug 'herringtonDarkholme/yats.vim'                                 " .ts
Plug 'mattn/emmet-vim'                                              " .html
Plug 'omnisharp/omnisharp-vim'                                      " .cs
Plug 'pedrohdz/vim-yaml-folds'                                      " .yaml
Plug 'udalov/kotlin-vim'                                            " .kotlin

" Git Tool
Plug 'idanarye/vim-merginal'                                        " Git branch organiser
Plug 'junegunn/gv.vim'                                              " Git commit history browser
Plug 'tpope/vim-fugitive'                                           " Git on Vim
Plug 'tpope/vim-rhubarb'                                            " Github on Vim
Plug 'tyru/open-browser-github.vim'                                 " Open Github URL
Plug 'tyru/open-browser.vim'                                        " Open URL

" Pairing
Plug 'andrewRadev/tagalong.vim'                                     " Change tag pairs automatically
Plug 'jiangmiao/auto-pairs'                                         " Automatic closing ({['']})
Plug 'machakann/vim-sandwich'                                       " Easy text wrap tool
Plug 'tmhedberg/matchit'                                            " More functionality to %
Plug 'tpope/vim-repeat'                                             " Repeat tpope's plugins

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocUpdate'}

" Search Tool
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                             " Fuzzy find files/content/tags

" Functionality
Plug 'airblade/vim-rooter'                                          " Find the root of the project automatically
Plug 'arithran/vim-delete-hidden-buffers'                           " Delete Hidden Buffer
Plug 'dominikduda/vim_current_word'                                 " Highlight current word
Plug 'easymotion/vim-easymotion'                                    " Easy Navigation
Plug 'godlygeek/tabular'                                            " Text Aligning Tool
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  } " InstantMarkdownPreview
Plug 'mattesGroeger/vim-bookmarks'                                  " Vim Bookmarks
Plug 'nicwest/vim-http'                                             " Indentation line
Plug 'scrooloose/nerdcommenter'                                     " Easy Commenting tool
Plug 'skywind3000/asyncrun.vim'                                     " Asyncrun tasks
Plug 'wesQ3/vim-windowswap'                                         " Split Panel switch
Plug 'yggdroot/indentLine'                                          " Indentation line

" Test
Plug 'vim-test/vim-test'                                            " Test files

" Snippets
Plug 'honza/vim-snippets'                                           " snippets
Plug 'andrewstuart/vim-kubernetes'                                  " Kubernetes snippets

call plug#end()
