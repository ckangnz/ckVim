call plug#begin('~/.vim/plugged')

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


" Essential
Plug 'dstein64/vim-startuptime'                                     " Show :StartupTime
Plug 'nvim-lua/plenary.nvim'                                        " Essential for nvim plugins
Plug 'markonm/traces.vim'                                           " Preview highlights and substitute
Plug 'mbbill/undotree'                                              " Magic of Undos
Plug 'stevearc/oil.nvim'                                            " Easy Netrw with '-'
Plug 'Exafunction/codeium.vim', {'branch':'main'}                   " AI Coding

" VIM GUI
Plug 'levouh/tint.nvim'                                             " Dim inactive window
Plug 'nvim-lualine/lualine.nvim'                                    " Status line
Plug 'nvim-tree/nvim-web-devicons'                                  " Devicons
Plug 'sainnhe/gruvbox-material'                                     " Gruvbox Theme
Plug 'skywind3000/vim-quickui'                                      " Context Quick UI

" Language Specific
Plug 'mattn/emmet-vim'                                              "HTML/CSS emmet
Plug 'nvim-treesitter/nvim-treesitter'                              "Syntax highlight by treesitter
Plug 'pedrohdz/vim-yaml-folds'                                      "Fold method for .yaml

" Git Tool
Plug 'idanarye/vim-merginal'                                        " Git branch organiser
Plug 'junegunn/gv.vim'                                              " Git commit history browser
Plug 'tpope/vim-fugitive'                                           " Git on Vim
Plug 'tpope/vim-rhubarb'                                            " Github on Vim
Plug 'tyru/open-browser-github.vim'                                 " Open Github URL
Plug 'tyru/open-browser.vim'                                        " Open URL
Plug 'pwntester/octo.nvim'

" Pairing
Plug 'machakann/vim-sandwich'                                       " Easy text wrap tool
Plug 'tmhedberg/matchit'                                            " More functionality to %
Plug 'tpope/vim-repeat'                                             " Repeat tpope's plugins
Plug 'windwp/nvim-autopairs'                                         " Automatic closing ({['']})

" LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}                     "Language server protocol

" Search Tool
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }         " Fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }   " FZF Extension
Plug 'nvim-telescope/telescope-project.nvim'                        " Project management
Plug 'fannheyward/telescope-coc.nvim'                               " Coc Extension
Plug 'tom-anders/telescope-vim-bookmarks.nvim'                      " Bookmarks Extension

" Functionality
Plug 'airblade/vim-rooter'                                          " Find the root of the project automatically
Plug 'Asheq/close-buffers.vim'                                      " Delete hidden buffers
Plug 'dominikduda/vim_current_word'                                 " Highlight current word
Plug 'easymotion/vim-easymotion'                                    " Easy Navigation
Plug 'folke/todo-comments.nvim'                                     " Highlight Todo comments
Plug 'kkvh/vim-docker-tools'                                        " Docker within vim
Plug 'wallpants/github-preview.nvim'                                " Markdown preview in Github style
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
