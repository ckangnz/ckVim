"---------AI Toolkit: Exafunction/codeium.vim
":Codeium Auth
let g:codeium_disable_bindings = 1
let g:codeium_manual = v:true

command! -nargs=0 OpenCodeiumChat :call codeium#Chat()

if has('unix') && has('mac')
  "Mac
  imap <script><silent><nowait><expr> <C-g> codeium#Accept()
  imap ‘ <cmd>call codeium#CycleCompletions(1)<cr>
  imap “ <cmd>call codeium#CycleCompletions(-1)<cr>
  imap <C-a> <Cmd>call codeium#Complete()<CR>
else
  "Linux
  imap <script><silent><nowait><expr> <C-g> codeium#Accept()
  imap <M-n> <cmd>call codeium#CycleCompletions(1)<cr>
  imap <M-p> <cmd>call codeium#CycleCompletions(-1)<cr>
  imap <C-a> <Cmd>call codeium#Complete()<CR>
endif
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

