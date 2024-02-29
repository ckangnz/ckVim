"----QUICK-UI: skywind3000/vim-quickui
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'papercol-dark'

"*-*-*-*-*-*-MY PATH MENU-*-*-*-*-*-*
let myPathsOpts={ "title": "My Paths" }
let myPaths=[]
call add(myPaths,[" ~/code (&d)",'vsp $HOME/code'])
if exists('g:neovide') || has('nvim')
  call add(myPaths,['Vimrc (&v)','vsp $HOME/.vimrc'])
  call add(myPaths,['NVim (&b)','vsp $MYVIMRC'])
else
  call add(myPaths,['Vimrc (&v)','vsp $MYVIMRC'])
endif
call add(myPaths,['-'])
call add(myPaths,['Readme.md (&r)','vsp $HOME/.vim/README.md'])
call add(myPaths,['Install.sh (&i)','vsp $HOME/.vim/install.sh'])
call add(myPaths,['-'])
call add(myPaths,['General (&g)','vsp $HOME/.vim/.config/nvim/lua/core/general.vim'])
call add(myPaths,['Plugin (&p)','vsp $HOME/.vim/.config/nvim/lua/core/plugins.vim'])
call add(myPaths,['Plugin Configurations (&c)','vsp $HOME/.vim/.config/nvim/lua/plugins'])
call add(myPaths,['-'])
call add(myPaths,['Zshrc (&z)','vsp $HOME/.zshrc'])
call add(myPaths,['Zsh Plugin (&l)','vsp $HOME/.vim/plugins.zsh'])
call add(myPaths,['-'])
call add(myPaths,['Notes (&n)','vsp $HOME/.vim/notes'])
call add(myPaths,['Helps (&h)','vsp $HOME/.vim/notes/vimhelp.md'])
nnoremap <nowait><silent><leader>e :call quickui#context#open(myPaths, myPathsOpts)<cr>
nmap <silent><leader>pi :PlugInstall<cr>
nmap <silent><leader>pu :PlugUpdate<cr>

"*-*-*-*-*-*-MY UTILITY MENU-*-*-*-*-*-*
let g:utilOpts = {'title': 'Utility Menu'}
let g:utilContent = []

call add(g:utilContent, [ 'Generate GUID (&i)', 'call GenerateGUID()' ])
call add(g:utilContent, [ 'Delete all white spaces (&w)', '%s/^$\\|^\s\+//g' ])
call add(g:utilContent, ['-'])
"----MARKDOWN PREVIEW: iamcco/markdown-preview.nvim
let g:mkdp_auto_start = 0
call add(g:utilContent, [ 'Markdown Preview (&d)', 'MarkdownPreview' ])
call add(g:utilContent, [ 'Yaml Schema (&y)', 'CocCommand yaml.selectSchema' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Clear Registers (&x)', 'call ClearReg()' ])

nnoremap <silent><nowait><leader>m :call quickui#context#open(g:utilContent, g:utilOpts)<cr>
