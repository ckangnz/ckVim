"---------AI Toolkit: Exafunction/codeium.vim
":Codeium Auth
let g:codeium_disable_bindings = 1
let g:codeium_manual = v:true

command! -nargs=0 OpenCodeiumChat :call codeium#Chat()

imap <script><silent><nowait><expr> <C-;> codeium#Accept()
imap <C-.> <cmd>call codeium#CycleOrComplete()<cr>
imap <C-,> <cmd>call codeium#CycleCompletions(-1)<cr>
imap <C-i> <Cmd>call codeium#Complete()<CR>

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

