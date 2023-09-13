filetype off                                                        " required

call plug#begin('~/.vim/plugged')

" VIM GUI
Plug 'sainnhe/gruvbox-material'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'skywind3000/vim-quickui'                                      " Context Quick UI
Plug 'tpope/vim-vinegar'                                            " Easy Netrw with '-'
Plug 'dstein64/vim-startuptime'                                     " Show :StartupTime
Plug 'levouh/tint.nvim'                                             " Dim inactive window
Plug 'junegunn/goyo.vim'                                            " Silence view
Plug 'markonm/traces.vim'                                           " Preview highlights and substitute
Plug 'mbbill/undotree'                                              " Magic of Undos

" Language Specific
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'pedrohdz/vim-yaml-folds'                                      " .yaml

" Git Tool
Plug 'idanarye/vim-merginal'                                        " Git branch organiser
Plug 'junegunn/gv.vim'                                              " Git commit history browser
Plug 'tpope/vim-fugitive'                                           " Git on Vim
Plug 'tpope/vim-rhubarb'                                            " Github on Vim
Plug 'tyru/open-browser-github.vim'                                 " Open Github URL
Plug 'tyru/open-browser.vim'                                        " Open URL
Plug 'Exafunction/codeium.vim', {'branch':'main'}                   " AI Coding

" Pairing
Plug 'jiangmiao/auto-pairs'                                         " Automatic closing ({['']})
Plug 'machakann/vim-sandwich'                                       " Easy text wrap tool
Plug 'tmhedberg/matchit'                                            " More functionality to %
Plug 'tpope/vim-repeat'                                             " Repeat tpope's plugins

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Search Tool
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'                                " Fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }   " FZF Extension
Plug 'fannheyward/telescope-coc.nvim'                               " Coc Extension
Plug 'tom-anders/telescope-vim-bookmarks.nvim'                      " Bookmarks Extension

" Functionality
Plug 'airblade/vim-rooter'                                          " Find the root of the project automatically
Plug 'Asheq/close-buffers.vim'                                      " Delete hidden buffers
Plug 'dominikduda/vim_current_word'                                 " Highlight current word
Plug 'easymotion/vim-easymotion'                                    " Easy Navigation
Plug 'kkvh/vim-docker-tools'                                        " Docker within vim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  } " InstantMarkdownPreview
Plug 'mattesGroeger/vim-bookmarks'                                  " Vim Bookmarks
Plug 'nicwest/vim-http'                                             " HTTP calls from vim
Plug 'scrooloose/nerdcommenter'                                     " Easy Commenting tool
Plug 'skywind3000/asyncrun.vim'                                     " Asyncrun tasks
Plug 'wesQ3/vim-windowswap'                                         " Split Panel switch

" Test
Plug 'vim-test/vim-test'                                            " Test files

"DB
Plug 'tpope/vim-dadbod'                                             " DB Manager
Plug 'kristijanhusak/vim-dadbod-ui'                                 " DB Manager UI

" Snippets
Plug 'honza/vim-snippets'                                           " snippets
Plug 'andrewstuart/vim-kubernetes'                                  " Kubernetes snippets

call plug#end()

filetype plugin indent on
:filetype indent on
