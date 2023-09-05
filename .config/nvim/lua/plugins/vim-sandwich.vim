"----------SANDWICH: machakann/vim-sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
      \{'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
      \{'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
      \{'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
      \ ]

xmap is <Plug>(textobj-sandwich-auto-i)
xmap as <Plug>(textobj-sandwich-auto-a)
omap is <Plug>(textobj-sandwich-auto-i)
omap as <Plug>(textobj-sandwich-auto-a)
hi OperatorSandwichChange ctermfg=109 ctermbg=237 guifg=#83a598 guibg=#3c3836
hi OperatorSandwichAdd cterm=bold ctermfg=10 gui=bold guifg=#7fbf00
hi OperatorSandwichDelete cterm=bold ctermfg=10 gui=bold guifg=#fb4934
