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

hi diffAdded ctermfg=142 guifg=#a9b665
hi diffRemoved ctermfg=167 guifg=#ea6962

hi Search ctermfg=black ctermbg=white guifg=black guibg=white
hi CurSearch cterm=reverse,bold gui=reverse,bold

hi CodeiumSuggestion guifg=#928374 ctermfg=245

"Transparent Neovim
if !exists('neovide')
  hi Normal guibg=NONE ctermbg=NONE
endif
hi NormalNC guibg=NONE ctermbg=NONE
hi Comment guibg=NONE ctermbg=NONE
hi Constant guibg=NONE ctermbg=NONE
hi Special guibg=NONE ctermbg=NONE
hi Identifier guibg=NONE ctermbg=NONE
hi Statement guibg=NONE ctermbg=NONE
hi PreProc guibg=NONE ctermbg=NONE
hi Type guibg=NONE ctermbg=NONE
hi Underlined guibg=NONE ctermbg=NONE
hi Todo guibg=NONE ctermbg=NONE
hi String guibg=NONE ctermbg=NONE
hi Function guibg=NONE ctermbg=NONE
hi Conditional guibg=NONE ctermbg=NONE
hi Repeat guibg=NONE ctermbg=NONE
hi Operator guibg=NONE ctermbg=NONE
hi Structure guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi CursorLine guibg=NONE ctermbg=NONE
hi CursorLineNr guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
