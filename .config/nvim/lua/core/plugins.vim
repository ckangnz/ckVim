call plug#begin('~/.vim/plugged')

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

"NVIM Dependencies
Plug 'nvim-lua/plenary.nvim'                                         " Essential for nvim plugins
Plug 'nvim-tree/nvim-web-devicons'                                   " Devicons

" Essential
Plug 'dstein64/vim-startuptime'                                      " Show :StartupTime
Plug 'stevearc/oil.nvim', { 'on': '-' }                              " Easy Netrw with '-'

" AI
Plug 'zbirenbaum/copilot.lua', { 'cmd': 'Copilot' }                  " Github Copilot
Plug 'AndreM222/copilot-lualine'                                     " Github Copilot lualine
Plug 'olimorris/codecompanion.nvim'                                  " Chat agent
Plug 'franco-ruggeri/codecompanion-spinner.nvim'                     " CodeCompanion loader
Plug 'franco-ruggeri/codecompanion-lualine.nvim'                     " CodeCompanion lualine
Plug 'ravitemer/mcphub.nvim', { 'do': 'npm install -g mcp-hub@latest'}  " MCP Hub
Plug 'Exafunction/windsurf.vim', { 'branch': 'main', 'cmd': 'Codeium' } " Windsurf AI

" VIM GUI
Plug 'nvim-lualine/lualine.nvim'                                     " Status line
Plug 'sainnhe/gruvbox-material'                                      " Gruvbox Theme
Plug 'skywind3000/vim-quickui'                                       " Context Quick UI
Plug 'sphamba/smear-cursor.nvim'                                     " Smooth cursor

" Language Specific
Plug 'mattn/emmet-vim', { 'for':
      \[ 'html', 'css', 'javascriptreact', 'typescriptreact'] }      " HTML/CSS emmet
Plug 'MeanderingProgrammer/render-markdown.nvim'                     " Markdown renderer
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'event': 'BufReadPre' } " Syntax highlight by treesitter
Plug 'pedrohdz/vim-yaml-folds', { 'for': [ 'yaml' ] }                " Fold method for .yaml

" Git Tool
Plug 'junegunn/gv.vim', { 'cmd': [ 'GV', 'GV!' ] }                   " Git commit history browser
Plug 'rhysd/vim-syntax-codeowners', { 'for': [ 'CODEOWNERS' ] }      " Git commit history browser
Plug 'tpope/vim-fugitive', { 'cmd': [ 'G', 'Git' ] }                 " Git on Vim
Plug 'tpope/vim-rhubarb'                                             " Github on Vim
Plug 'tyru/open-browser-github.vim'                                  " Open Github URL
Plug 'tyru/open-browser.vim'                                         " Open URL

" Pairing
Plug 'machakann/vim-sandwich'                                        " Easy text wrap tool
Plug 'tpope/vim-repeat'                                              " Repeat tpope's plugins
Plug 'windwp/nvim-autopairs', { 'event': 'InsertEnter' }             " Automatic closing ({['']})

" LSP
Plug 'neoclide/coc.nvim', { 'branch': 'release' }                    " Language server protocol

" Search Tool
Plug 'nvim-telescope/telescope.nvim', { 'branch': 'master' }         " Fuzzy finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }    " FZF Extension
Plug 'nvim-telescope/telescope-project.nvim'                         " Project management
Plug 'fannheyward/telescope-coc.nvim'                                " Coc Extension
Plug 'tom-anders/telescope-vim-bookmarks.nvim'                       " Bookmarks Extension

" Functionality
Plug 'Asheq/close-buffers.vim', { 'cmd': [ 'Bdelete', 'Bwipeout' ] } " Delete hidden buffers
Plug 'AndrewRadev/switch.vim', { 'cmd': [ 'Switch', 'SwitchReverse' ] } " Delete hidden buffers
Plug 'airblade/vim-rooter'                                           " Find the root of the project automatically
Plug 'dominikduda/vim_current_word'                                  " Highlight current word
Plug 'easymotion/vim-easymotion'                                     " Easy Navigation
Plug 'folke/todo-comments.nvim'                                      " Highlight Todo comments
Plug 'jannis-baum/vivify.vim', { 'for': [ 'markdown' ] }             " Markdown Previewer
Plug 'kkvh/vim-docker-tools', { 'cmd': [ 'DockerToolsToggle' ] }     " Docker within vim
Plug 'markonm/traces.vim'                                            " Preview highlights and substitute
Plug 'mattesGroeger/vim-bookmarks'                                   " Vim Bookmarks
Plug 'mbbill/undotree'                                               " Magic of Undos
Plug 'mistweaverco/kulala.nvim', { 'cmd': [ 'Kulala' ] }             " HTTP client for nvim
Plug 'scrooloose/nerdcommenter'                                      " Easy Commenting tool
Plug 'skywind3000/asyncrun.vim'                                      " Asyncrun tasks
Plug 'wesQ3/vim-windowswap'                                          " Split Panel switch

" Test
Plug 'vim-test/vim-test', { 'cmd': [ 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' ] } " Test files

" DB
Plug 'tpope/vim-dadbod', { 'cmd': [ 'DB', 'DBUI' ] }                  " DB Manager
Plug 'kristijanhusak/vim-dadbod-ui', { 'cmd': [ 'DBUI' ] }            " DB Manager UI

" Snippets
Plug 'andrewstuart/vim-kubernetes', { 'for': [ 'yaml' ] }            " Kubernetes snippets

call plug#end()

nmap <silent><leader>pp :PlugUpgrade<cr>
nmap <silent><leader>pi :PlugInstall<cr>
nmap <silent><leader>pu :PlugUpdate<cr>
nmap <silent><leader>pd :PlugDiff<cr>
nmap <silent><leader>pc :PlugClean<cr>
