"---------HTTP RESTFUL CALLS: nicwest/vim-http
let g:vim_http_clean_before_do=0
let g:vim_http_split_vertically=1
let g:vim_http_tempbuffer=1
let g:vim_http_additional_curl_args='-k'
func! s:set_json_header() abort
  call http#set_header('Content-Type', 'application/json')
endfunc
func! s:clean_personal_stuff() abort
  call http#remove_header('Cookie')
  call http#remove_header('Accept')
  call http#remove_header('User-Agent')
  call http#remove_header('Accept-Language')
endfunc
func! s:add_compression() abort
  call http#set_header('Accept-Encoding', 'deflate, gzip')
  let g:vim_http_additional_curl_args = '--compressed'
endfunc
command! HttpJson call s:set_json_header()
command! HttpAnon call s:clean_personal_stuff()
command! HttpCompression call s:add_compression()
