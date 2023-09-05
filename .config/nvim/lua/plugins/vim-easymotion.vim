"----------EASYMOTION: easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
nmap F <Plug>(easymotion-overwin-f2)
hi link EasyMotionTarget IncSearch
hi link EasyMotionShade Comment
hi link EasyMotionTarget2First MatchParen
hi link EasyMotionTarget2Second MatchParen
hi link EasyMotionMoveHL Search
hi link EasyMotionIncSearch IncSearch

