augroup autosourcing
  au!
  let b:auto_source_in_progress = get(b:, 'auto_source_in_progress', 0)
  if !b:auto_source_in_progress
    let b:auto_source_in_progress = 1

    " Source .vimrc and Nvim config files when they are written
    if has('nvim') || exists('g:neovide')
      au BufWritePost {expand('$HOME')}/.vimrc source {expand('$MYVIMRC')}
    endif
    au BufWritePost {expand('$MYVIMRC')} source {expand('$MYVIMRC')}
    au BufWritePost {expand('$HOME')}/.vim/.config/nvim/* source {expand('$MYVIMRC')}

  endif

  au BufNewFile,BufRead *.ejs set filetype=js
  au BufNewFile,BufRead *.vue,*.hbs set filetype=html
  au BufNewFile,BufRead *.jsx set filetype=javascriptreact
  au BufNewFile,BufRead *.tsx set filetype=typescriptreact
  au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
  au BufRead,BufNewFile *.{yaml,yml} set filetype=yaml

  au BufRead,InsertEnter * setlocal cursorline
  au VimEnter,InsertLeave * setlocal cursorline

  au BufRead * setlocal includeexpr=substitute(v:fname,'\\.','/','g')
augroup END
