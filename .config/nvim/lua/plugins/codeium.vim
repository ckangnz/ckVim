"---------AI Toolkit: Exafunction/codeium.vim
":Codeium Auth
let g:codeium_disable_bindings = 1
let g:codeium_manual = v:true
if has('unix') && has('mac')
  "Mac
  imap <script><silent><nowait><expr> ≠ codeium#Accept()
  imap ‘ <Plug>(codeium-next)
  imap “ <Plug>(codeium-previous)
  imap œ <Plug>(codium-dismiss)
  imap å <Cmd>call codeium#Complete()<CR>
else
  "Linux
  imap <script><silent><nowait><expr> <M-=> codeium#Accept()
  imap <M-]> <Plug>(codeium-next)
  imap <M-[> <Plug>(codeium-previous)
  imap <M-q> <Plug>(codium-dismiss)
  imap <M-a> <Cmd>call codeium#Complete()<CR>
endif
let g:airline_section_y = 'AI:%3{codeium#GetStatusString()}'
let g:codeium_filetypes = {
    \ "cs": v:true,
    \ "vim": v:true,
    \ "python": v:true,
    \ "html": v:true,
    \ "css": v:true,
    \ "sass": v:true,
    \ "json": v:true,
    \ "flutter": v:true,
    \ "kotlin": v:true,
    \ "lua": v:true,
    \ "docker": v:true,
    \ "javascript": v:true,
    \ "javascriptreact": v:true,
    \ "typescript": v:true,
    \ "typescriptreact": v:true,
    \ }

