set background=dark
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_palette = "original"
let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material

let g:airline_theme='gruvbox_material'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ycm#enabled = 0
let g:airline_left_sep = ""
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#left_sep=""
let airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#show_coc_status = 0
let g:airline_section_y = airline#section#create(["%{coc#status()}%{get(b:,'coc_current_function','')}"])
let g:airline_section_z = airline#section#create(['%{g:airline_symbols.linenr}%#__accent_bold#%3l/%3L', '%{g:airline_symbols.colnr}%#__accent_bold#%3v'])
let g:airline_section_error = airline#section#create(['%{g:asyncrun_status}'])
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n' : '',
      \ 'i' : '',
      \ 'R' : '',
      \ 'c' : '',
      \ 'v' : '󰸱',
      \ 'V' : '󰸱',
      \ '' : '󰸱',
      \ }
