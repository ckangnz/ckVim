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

hi foldcolumn ctermbg=0 guibg=bg guifg=white
hi Comment cterm=NONE
hi diffAdded ctermfg=142 guifg=#a9b665
hi diffRemoved ctermfg=167 guifg=#ea6962

hi Search ctermfg=black ctermbg=white guifg=black guibg=white
hi CurSearch cterm=reverse,bold gui=reverse,bold

hi CodeiumSuggestion guifg=#928374 ctermfg=245

"Transparent Neovim
if !exists('neovide')
  hi Normal guibg=none ctermbg=none
endif
hi NormalNC guibg=none ctermbg=none
hi Comment guibg=none ctermbg=none
hi Constant guibg=none ctermbg=none
hi Special guibg=none ctermbg=none
hi Identifier guibg=none ctermbg=none
hi Statement guibg=none ctermbg=none
hi PreProc guibg=none ctermbg=none
hi Type guibg=none ctermbg=none
hi Underlined guibg=none ctermbg=none
hi Todo guibg=none ctermbg=none
hi String guibg=none ctermbg=none
hi Function guibg=none ctermbg=none
hi Conditional guibg=none ctermbg=none
hi Repeat guibg=none ctermbg=none
hi Operator guibg=none ctermbg=none
hi Structure guibg=none ctermbg=none
hi LineNr guibg=none ctermbg=none
hi NonText guibg=none ctermbg=none
hi SignColumn guibg=none ctermbg=none
hi CursorLine guibg=none ctermbg=none
hi CursorLineNr guibg=none ctermbg=none
hi EndOfBuffer guibg=none ctermbg=none
