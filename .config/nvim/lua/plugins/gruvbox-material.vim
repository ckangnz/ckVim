if &background != 'dark'
  set background=dark
endif
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_disable_italic_comment = 0
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_palette = "original"
let g:gruvbox_material_background = 'hard'

if !exists('g:colors_name')
  silent! colorscheme gruvbox-material
endif
