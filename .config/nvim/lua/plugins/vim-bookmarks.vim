"---------BOOKMARKS: MattesGroeger/vim-bookmarks
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
let g:bookmark_auto_close = 1
let g:bookmark_center = 1

let bookmarkMenu = []
let bookmarkOpt={'title':'Bookmarks'}
call add(bookmarkMenu, ['Add/Delete bookmark (&m)', 'BookmarkToggle'])
call add(bookmarkMenu, ['Bookmark Annotate(&i)', 'BookmarkAnnotate'])
call add(bookmarkMenu, ['Bookmark Show all (&a)', 'BookmarkShowAll'])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Bookmark Next (&n)', 'BookmarkNext'])
call add(bookmarkMenu, ['Bookmark Previous (&p)', 'BookmarkPrev'])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Clear all bookmarks (&x)', 'BookmarkClearAll'])
noremap <silent><nowait>m :call quickui#context#open(bookmarkMenu, bookmarkOpt)<cr>

hi BookmarkSign ctermbg=NONE ctermfg=red guibg=NONE guifg=red
hi BookmarkLine ctermbg=NONE ctermfg=NONE guibg=#343434 guifg=NONE


