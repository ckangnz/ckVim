"----QUICK-UI: skywind3000/vim-quickui
let g:quickui_border_style = 2
let g:quickui_color_scheme = 'papercol-dark'

"*-*-*-*-*-*-MY PATH MENU-*-*-*-*-*-*
let myPathsOpts={ "title": "My Paths" }
let myPaths=[]
call add(myPaths,['.vimrc (&v)','vsp $HOME/.vimrc'])
call add(myPaths,['init.lua (&b)','vsp $HOME/.vim/.config/nvim/init.lua'])
call add(myPaths,['.zshrc (&z)','vsp $HOME/.zshrc'])
call add(myPaths,['.extraAlias.zsh (&a)','vsp $HOME/.extraAlias.zsh'])
call add(myPaths,['.tmux.conf (&t)','e $HOME/.config/tmux/tmux.conf'])
call add(myPaths,['general.vim (&g)','vsp $HOME/.vim/.config/nvim/lua/core/general.vim'])
call add(myPaths,['plugins.vim (&p)','vsp $HOME/.vim/.config/nvim/lua/core/plugins.vim'])
call add(myPaths,['plugins.zsh (&l)','vsp $HOME/.vim/plugins.zsh'])
call add(myPaths,['Makefile (&m)','vsp $HOME/.vim/Makefile'])
call add(myPaths,['install_vim.sh (&i)','vsp $HOME/.vim/install_vim.sh'])
call add(myPaths,['vimhelp.md (&h)','vsp $HOME/.vim/notes/vimhelp.md'])
call add(myPaths,['-'])
call add(myPaths,[" ~/.vim (&e)",'vsp $HOME/.vim'])
call add(myPaths,[" ~/code (&d)",'vsp $HOME/code'])
call add(myPaths,['/plugins (&c)','vsp $HOME/.vim/.config/nvim/lua/plugins'])
call add(myPaths,['/notes (&n)','vsp $HOME/.vim/notes'])
call add(myPaths,['readme.md (&r)','vsp $HOME/.vim/README.md'])
nnoremap <nowait><silent><leader>e :call quickui#context#open(myPaths, myPathsOpts)<cr>

"*-*-*-*-*-*-MY UTILITY MENU-*-*-*-*-*-*
let g:utilOpts = {'title': 'Utility Menu'}
let g:utilContent = []

call add(g:utilContent, [ 'Generate GUID (&i)', 'call GenerateGUID()' ])
call add(g:utilContent, [ 'Delete all white spaces (&w)', '%s/^$\\|^\s\+//g' ])
call add(g:utilContent, ['-'])
call add(g:utilContent, [ 'Render Markdown toggle (&r)', 'RenderMarkdown toggle' ])
call add(g:utilContent, [ 'Vivify (Markdown Renderer) (&d)', 'Vivify' ])
call add(g:utilContent, [ 'Yaml Schema (&y)', 'CocCommand yaml.selectSchema' ])
call add(g:utilContent, ['-'])

call add(g:utilContent, [ 'Clear Registers (&x)', 'call ClearReg()' ])

nnoremap <silent><nowait><leader>m :call quickui#context#open(g:utilContent, g:utilOpts)<cr>
