"neoclide/coc.nvim
let g:coc_user_config = {}

" Extensions
let g:coc_global_extensions = [
      \ 'coc-vimlsp',
      \ 'coc-lua',
      \ 'coc-emmet',
      \ 'coc-css',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-swagger',
      \ 'coc-prettier',
      \ 'coc-tsserver',
      \ 'coc-docker',
      \ 'coc-csharp-ls',
      \ 'coc-eslint',
      \ 'coc-snippets',
      \ 'coc-db',
      \ 'coc-flutter',
      \ 'coc-kotlin'
      \]

" Key bindings
nmap <silent><nowait>gh <Plug>(coc-diagnostic-info)
nmap <silent><nowait>gd <Plug>(coc-definition)
nmap <silent><nowait>gy <Plug>(coc-type-definition)
nmap <silent><nowait>gi <Plug>(coc-implementation)
nmap <silent><nowait><S-r> <Plug>(coc-rename)
nmap <silent><nowait><leader><S-r> :CocCommand workspace.renameCurrentFile<cr>
xmap <nowait><leader>= <Plug>(coc-format-selected)
nmap <nowait><leader>= <Plug>(coc-format)
xmap <nowait><leader>ac <Plug>(coc-codeaction-selected)
nmap <nowait><leader>ac <Plug>(coc-codeaction-selected)
nmap <nowait><leader>ap <Plug>(coc-diagnostic-prev)
nmap <nowait><leader>an <Plug>(coc-diagnostic-next)
nmap <nowait><leader>r <Plug>(coc-codeaction-refactor)
xmap <nowait><leader>r <Plug>(coc-codeaction-refactor-selected)
nmap <nowait><leader>. <Plug>(coc-codeaction)
nmap <nowait><leader>. <Plug>(coc-fix-current)

" Popup menu control (scrolling)
nnoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-w><c-j>"
nnoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-w><c-k>"
inoremap <silent><expr> <c-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<c-w><c-j>"
inoremap <silent><expr> <c-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<c-w><c-k>"
vnoremap <silent><expr> <c-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-w><c-j>"
vnoremap <silent><expr> <c-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-w><c-k>"

" Custom Commands
command -nargs=0 Swagger :CocCommand swagger.render
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 Format         :call CocActionAsync('format')
command! -nargs=? Fold           :call CocActionAsync('fold', <f-args>)
command! -nargs=0 OrganizeImport :call CocActionAsync('runCommand', 'editor.action.organizeImport')
command! -nargs=0 RenameFile :CocCommand workspace.renameCurrentFile
command! -nargs=0 CocUndo :CocCommand workspace.undo
command! -nargs=0 CocRedo :CocCommand workspace.redo

let g:coc_snippet_next = '<tab>'
inoremap <silent><expr> <TAB>
  \ coc#pum#visible()?
  \ coc#_select_confirm() :
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ?
  \"\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

augroup cocOverride
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  "Javascript formatSelected
  autocmd FileType javasccript,javascriptreact,typescript,typescriptreact,json setl formatexpr=CocActionAsync('formatSelected')
  "Disable markdown suggestions
  autocmd FileType markdown let b:coc_suggest_disable = 1

  function! s:create_dotnet_controller() abort
    let controllerName = input('Controller Name: ')
    let modelName = input('Model Name: ')
    let dbContextName = input('DB Context Name: ')
    if controllerName != "" && modelName != "" && dbContextName != ""
      let script = ":!dotnet aspnet-codegenerator controller "
            \.. "-name " .. controllerName .. "Controller "
            \.. "-async "
            \.. "-api "
            \.. "-m " .. modelName .. " "
            \.. "-dc " .. dbContextName .. " "
            \.. "-outDir Controllers"
      exe script
    else
      echo "Cancelled"
    endif
  endfunction
  command! CreateController call s:create_dotnet_controller()
augroup end

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
