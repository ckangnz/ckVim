"========================================
" 📁 Auto-sourcing Config Files
"========================================
augroup AutoSourcing
  autocmd!
  let b:auto_source_in_progress = get(b:, 'auto_source_in_progress', 0)
  if !b:auto_source_in_progress
    let b:auto_source_in_progress = 1

    " Auto-source .vimrc or init.vim on save
    if has('nvim') || exists('g:neovide')
      autocmd BufWritePost $HOME/.vimrc source $MYVIMRC
    endif
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    autocmd BufWritePost $HOME/.vim/.config/nvim/* source $MYVIMRC
  endif
augroup END

"========================================
" 📁 Custom Filetypes
"========================================
augroup CustomFileTypes
  autocmd!
  autocmd BufNewFile,BufRead *.ejs set filetype=javascript
  autocmd BufNewFile,BufRead *.vue,*.hbs set filetype=html
  autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
  autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
  autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
  autocmd BufRead,BufNewFile *.{yaml,yml} set filetype=yaml
augroup END

