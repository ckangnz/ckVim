"---------BROWSERS: tyru/open-browser.vim, tyru/open-browser-github.vim
let gitOpt = {'title':'GITHUB Menu'}
let githubMenu = []
call add(githubMenu , ['Open PR (&r)', 'exec "OpenGithubPullReq #" . FugitiveHead()'])
call add(githubMenu , ['Open current file (&f)', 'OpenGithubFile'])
call add(githubMenu , ['Open project (&g)', 'OpenGithubProject'])
call add(githubMenu , ['Open issues (&i)', 'OpenGithubIssue'])
call add(githubMenu , ['Open pull requests (&p)', 'OpenGithubPullReq'])
noremap <silent><nowait><leader>go :call quickui#context#open(githubMenu, gitOpt)<cr>

