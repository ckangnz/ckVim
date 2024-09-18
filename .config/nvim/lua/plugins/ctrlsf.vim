let g:ctrlsf_auto_close = {
    \ "normal" : 0,
    \ "compact": 0
    \}

let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_auto_preview = 0
let g:ctrlsf_fold_result = 0

nmap <leader>h <Plug>CtrlSFPrompt
vmap <leader>h <Plug>CtrlSFVwordExec
nmap <leader>H <Plug>CtrlSFCwordPath

let g:ctrlsf_mapping = {
      \ "open": "o",
      \ "popen": "p",
      \ "nfile": "]]",
      \ "pfile": "[[",
      \ "next": "",
      \ "prev": "",
      \ "tab": "t",
      \ "vsplit": "<C-v>",
      \ "chgmode": "<space>",
      \ }
