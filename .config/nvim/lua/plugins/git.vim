"--------GIT: tpope/vim-fugitive / idanarye/vim-merginal / junegunn/gv.vim
nnoremap <silent> <Leader>1 :Git<cr><c-w>T
nnoremap <silent> <Leader>2 :GV --all<cr>
nnoremap <silent> <Leader>@ :GV!<cr>
vnoremap <silent> <Leader>2 :GV!<cr>
nnoremap <silent> <Leader>3 :execute len(FugitiveHead()) > 0 ? ':MerginalToggle' : 'echoerr "Not in a git repo"'<cr>
nnoremap <silent> <Leader>gc :Git commit<cr>
nnoremap <silent> <Leader>gr :Gread<cr>
nnoremap <silent> <Leader>gw :Gwrite<cr>
nnoremap <silent> <Leader>gd :Gdiff<cr>
nnoremap <silent> <Leader>gD :Gdiffsplit!<cr>
nnoremap <Leader>ge :Gedit<cr>
nnoremap <silent> <Leader>gb :Git blame<cr>
nnoremap <silent> <Leader>gp :AsyncRun git -c push.default=current push<cr>
nnoremap <silent> <Leader>gP :AsyncRun git push -f<cr>
nnoremap <silent> <Leader>gl :AsyncRun git pull<cr>
nnoremap <silent><Leader>gfo :AsyncRun git fetch origin
nnoremap <silent><Leader>gfa :AsyncRun git fetch --all --prune<cr>

func s:UpdateGitStatusLine() abort
  if !exists('*FugitiveExtractGitDir')
    return ''
  endif
  let dir = exists('b:git_dir') ? b:git_dir : FugitiveExtractGitDir(resolve(expand('%:p')))
  if empty(dir)
    return ''
  endif
  let b:git_dir = dir
endfunc

if has("autocmd")
  autocmd BufReadPost fugitive://* set bufhidden=delete
  au BufWinEnter,ShellCmdPost,BufWritePost * call s:UpdateGitStatusLine()
endif

