augroup autosourcing
  au!
  if exists('g:neovide') || has('nvim')
    au BufWritePost $HOME/.vimrc source $MYVIMRC
  endif
  au BufWritePost $MYVIMRC source $MYVIMRC
  au BufWritePost $HOME/.vim/.config/nvim/* source $MYVIMRC

  au BufNewFile,BufRead *.ejs set filetype=js
  au BufNewFile,BufRead *.vue,*.hbs set filetype=html
  au BufNewFile,BufRead *.jsx set filetype=javascriptreact
  au BufNewFile,BufRead *.tsx set filetype=typescriptreact

  au BufRead,InsertEnter * setlocal cursorline
  au VimEnter,InsertLeave * setlocal cursorline

  au BufRead * setlocal includeexpr=substitute(v:fname,'\\.','/','g')
augroup END
