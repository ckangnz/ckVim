" ==========================================
" Coc.nvim Configuration
" ==========================================

" Global Extensions
let g:coc_global_extensions = [
  \ 'coc-vimlsp',
  \ 'coc-lua',
  \ 'coc-sh',
  \ 'coc-html',
  \ 'coc-emmet',
  \ 'coc-css',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-json',
  \ 'coc-yaml',
  \ '@yaegassy/coc-csharp-ls',
  \ 'coc-java',
  \ 'coc-kotlin',
  \ 'coc-swagger',
  \ 'coc-prettier',
  \ 'coc-docker',
  \ 'coc-snippets',
  \ 'coc-db',
  \ 'coc-terraform',
  \ 'coc-flutter',
\]

" ==========================================
" Key Mappings
" ==========================================

" Navigation & Actions
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> <S-r> <Plug>(coc-rename)
nmap <silent><nowait> <leader><S-r> :CocCommand workspace.renameCurrentFile<CR>

" Formatting
vmap <silent><nowait> <leader>= <Plug>(coc-format-selected)
nmap <silent><nowait> <leader>= <Plug>(coc-format)

" Diagnostics
nmap <silent><nowait> gap <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> gan <Plug>(coc-diagnostic-next)

" Code Actions
xmap <silent> ga <Plug>(coc-codeaction-selected)
nmap <silent><nowait> ga. <Plug>(coc-codeaction-cursor)
nmap <nowait> <leader>r <Plug>(coc-codeaction-refactor)
xmap <nowait> <leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <silent><nowait> ga<CR> <Plug>(coc-fix-current)
nmap <silent><nowait> <leader>h :CocSearch<space>

" Documentation (Hover)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if index(['vim', 'help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" ==========================================
" Popup Menu Scrolling
" ==========================================

nnoremap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-w>\<C-j>"
nnoremap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-w>\<C-k>"
inoremap <silent><expr> <C-j> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<C-w>\<C-j>"
inoremap <silent><expr> <C-k> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<C-w>\<C-k>"
vnoremap <silent><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-w>\<C-j>"
vnoremap <silent><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-w>\<C-k>"

" ==========================================
" Commands
" ==========================================

command! -nargs=0 Swagger         :CocCommand swagger.render
command! -nargs=0 Prettier        :CocCommand prettier.formatFile
command! -nargs=0 Format          :call CocActionAsync('format')
command! -nargs=? Fold            :call CocActionAsync('fold', <f-args>)
command! -nargs=0 OrganizeImport  :call CocActionAsync('runCommand', 'editor.action.organizeImport')
command! -nargs=0 RenameFile      :CocCommand workspace.renameCurrentFile
command! -nargs=0 CocUndo         :CocCommand workspace.undo
command! -nargs=0 CocRedo         :CocCommand workspace.redo

" ==========================================
" Autocommands
" ==========================================

augroup cocOverride
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  " Javascript/Typescript formatSelected
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json setl formatexpr=CocActionAsync('formatSelected')

  " Disable markdown suggestions
  autocmd FileType markdown let b:coc_suggest_disable = 1
augroup END
