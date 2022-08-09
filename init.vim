set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

augroup autosourcing
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePost $HOME/.vimrc source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/general.vim source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/plugins.vim source $MYVIMRC

    autocmd BufWritePost $MYVIMRC AirlineRefresh
    autocmd BufWritePost $HOME/.vimrc AirlineRefresh
    autocmd BufWritePost $HOME/.vim/general.vim AirlineRefresh
    autocmd BufWritePost $HOME/.vim/plugins.vim AirlineRefresh
augroup END

"NEOVIDE SPECIFIC
if exists("g:neovide")
  let g:neovide_transparency=1
  let g:neovide_floating_blur_amount_x = 5.0
  let g:neovide_floating_blur_amount_y = 5.0
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

  "Changing tabs
  map <D-[> gT
  map <D-]> gt
endif

