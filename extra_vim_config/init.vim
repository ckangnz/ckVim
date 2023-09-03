set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $HOME/.vimrc

"NEOVIDE SPECIFIC
if exists("g:neovide")
  let g:neovide_transparency=0.0
  let g:transparency = 0.9
  let g:neovide_background_color = '#282828'.printf('%x', float2nr(255 * g:transparency))

  let g:neovide_floating_blur_amount_x = 2
  let g:neovide_floating_blur_amount_y = 2
  let g:neovide_scroll_animation_length = 0.1
  let g:neovide_cursor_antialiasing=v:true
  let g:neovide_cursor_vfx_mode = "wireframe"
  let g:neovide_fullscreen=v:false

  "Cmd+C / Cmd+V on Neovide
  let g:neovide_input_use_logo = 1
  map <D-v> "+p<CR>
  map! <D-v> <C-R>+
  tmap <D-v> <C-R>+
  vmap <D-c> "+y<CR>

  map <D-s> :w<CR>

  "Changing tabs
  map <D-t> :tabedit<cr>
  map <D-[> gT
  map <D-]> gt
endif

