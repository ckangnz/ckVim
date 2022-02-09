filetype off                  " required

call plug#begin('~/.vim/plugged')

"Themes
Plug 'sainnhe/gruvbox-material'
Plug 'vim-airline/vim-airline'                                      "Vim Airline

"Syntax Highlighting
Plug 'pangloss/vim-javascript'                                      "JS syntax & indentation
Plug 'briancollins/vim-jst'                                         "EJS syntax & indentation
Plug 'udalov/kotlin-vim'                                            "Kotlin Syntax

"Git Tool
Plug 'idanarye/vim-merginal'                                        "Git branch organiser
Plug 'junegunn/gv.vim'                                              "Git commit history browser
Plug 'tpope/vim-fugitive'                                           "Git on Vim
Plug 'tpope/vim-rhubarb'                                            "Github on Vim
Plug 'tyru/open-browser-github.vim'                                 "Open Github URL
Plug 'tyru/open-browser.vim'                                        "Open URL

"General IDE Tools
Plug 'skywind3000/vim-quickui'                                      "Context Quick UI
Plug 'arithran/vim-delete-hidden-buffers'                           "Delete Hidden Buffer
Plug 'Yggdroot/indentLine'                                          "Indentation line
Plug 'godlygeek/tabular'                                            "Text Aligning Tool
Plug 'jiangmiao/auto-pairs'                                         "Automatic closing ({['']})
Plug 'mattn/emmet-vim'                                              "Emmet
Plug 'scrooloose/nerdcommenter'                                     "Easy Commenting tool
Plug 'tmhedberg/matchit'                                            "More functionality to %
Plug 'tpope/vim-surround'                                           "Easy text wrap tool
Plug 'tpope/vim-repeat'                                             "Repeat tpope's plugins
Plug 'tpope/vim-vinegar'                                            "Easy Netrw with '-'
Plug 'miyakogi/conoline.vim'                                        "Highlight current line
Plug 'pedrohdz/vim-yaml-folds'                                      "Yaml Folding
Plug 'Omnisharp/omnisharp-vim'                                      "C# Omnisharp for vim

"General Vim Tool
Plug 'gabrielelana/vim-markdown'                                    "Easy MD tools
Plug 'sotte/presenting.vim'                                         "Vim Presenting tool
Plug 'junegunn/goyo.vim'                                            "Silence view
Plug 'easymotion/vim-easymotion'                                    "Easy Navigation
Plug 'mbbill/undotree'                                              "Magic of Undos
Plug 'MattesGroeger/vim-bookmarks'                                  "Vim Bookmarks
Plug 'skywind3000/asyncrun.vim'                                     "Asyncrun tasks
Plug 'wesQ3/vim-windowswap'                                         "Split Panel switch
Plug 'dominikduda/vim_current_word'                                 "Highlight current word
Plug 'qxxxb/vim-searchhi'                                           "Highlight searched
Plug 'inside/vim-search-pulse'                                      "Pulse searched word
Plug 'iamcco/markdown-preview.nvim',
            \{ 'do': 'cd app && npm install'  }                    "InstantMarkdownPreview

"Search Tool
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                             "Fuzzy find files/content/tags
Plug 'antoinemadec/coc-fzf'                                         "Fzf for coc

"Completer
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocUpdate'}

"Test
Plug 'vim-test/vim-test'                                            "Test files

"Snippets
Plug 'honza/vim-snippets'                                           "snippets
Plug 'andrewstuart/vim-kubernetes'                                "Kubernetes snippets

"Docker
Plug 'skanehira/docker.vim'                                         "Docker

Plug 'ryanoasis/vim-devicons'

call plug#end()
