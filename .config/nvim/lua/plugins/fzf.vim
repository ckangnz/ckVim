"----FZF FINDER: junegunn/fzf
set rtp+=~/.fzf
let $FZF_DEFAULT_OPTS="--layout=reverse --bind ctrl-k:preview-up,ctrl-j:preview-down"
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*}"'
let g:fzf_layout={'window':{ 'width': 0.9, 'height': 0.6 }}
let g:fzf_preview_window = ['right:60%:hidden','?']
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-d': 'split',
      \ 'ctrl-v': 'vsplit' }
command! Ctrlp execute len(FugitiveHead()) > 0 ? ':GFiles' : ':Files'
nnoremap <silent> <C-p> :Ctrlp<CR>
nnoremap <silent> <C-e> :History<CR>
nnoremap <Leader>f :Rg<space>
vnoremap <Leader>f y:Rg <c-r>"<cr>
nnoremap <Leader>F :Rg <c-r><c-w><cr>
nnoremap <Leader>@ :BCommits<cr>

autocmd! FileType fzf
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

