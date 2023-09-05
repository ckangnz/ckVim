augroup WhitespaceMatch
  autocmd!
  func! s:ToggleWhitespaceMatch(mode)
    let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
    if exists('w:whitespace_match_number')
      call matchdelete(w:whitespace_match_number)
      call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
    else
      let w:whitespace_match_number = matchadd('ExtraWhitespace', pattern)
    endif
  endfunc

  autocmd BufWinEnter * let w:whitespace_match_number = matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END

hi ExtraWhitespace ctermbg=red guibg=red

hi LineNr ctermbg=0 guibg=bg
hi vertsplit ctermbg=0 guibg=bg
hi foldcolumn ctermbg=0 guibg=bg guifg=white
hi SignColumn guibg=bg
hi Comment cterm=NONE
hi diffAdded ctermfg=142 guifg=#a9b665
hi diffRemoved ctermfg=167 guifg=#ea6962

hi Search ctermfg=black ctermbg=white guifg=black guibg=white
hi CurSearch cterm=reverse,bold gui=reverse,bold

hi CodeiumSuggestion guifg=#928374 ctermfg=245

