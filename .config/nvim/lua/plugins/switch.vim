let g:switch_mapping = ""
let g:switch_custom_definitions =
    \ [
    \   ['!NOTE', '!TIP', '!IMPORTANT','!CAUTION', '!WARNING']
    \ ]

nnoremap <Bar>> :Switch<CR>
nnoremap <Bar>< :SwitchReverse<CR>
