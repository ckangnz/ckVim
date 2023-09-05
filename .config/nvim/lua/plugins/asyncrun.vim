let g:asyncrun_open = 0
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

