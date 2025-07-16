"---------BOOKMARKS: MattesGroeger/vim-bookmarks
let g:bookmark_sign = ' '
let g:bookmark_highlight_lines = 1
let g:bookmark_auto_close = 1
let g:bookmark_center = 1
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_disable_ctrlp = 1

let bookmarkMenu = []
let bookmarkOpt={'title':'Bookmarks'}
call add(bookmarkMenu, ['Add/Delete bookmark (&m)', 'BookmarkToggle'])
call add(bookmarkMenu, ['Bookmark Annotate(&i)', 'BookmarkAnnotate'])
call add(bookmarkMenu, ['-'])
"call add(bookmarkMenu, ['Show all bookmarks (&a)', "BookmarkShowAll"])
call add(bookmarkMenu, ['Bookmark Search (&s)', "lua require('telescope').load_extension('vim_bookmarks').all({ prompt_title='Bookmarks', prompt_prefix='📖 ' })"])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Bookmark MoveDown (&j)', 'BookmarkMoveDown'])
call add(bookmarkMenu, ['Bookmark MoveUp (&k)', 'BookmarkMoveUp'])
call add(bookmarkMenu, ['Bookmark Next (&n)', 'BookmarkNext'])
call add(bookmarkMenu, ['Bookmark Previous (&p)', 'BookmarkPrev'])
call add(bookmarkMenu, ['-'])
call add(bookmarkMenu, ['Clear bookmarks (&c)', 'BookmarkClear'])
call add(bookmarkMenu, ['Clear all bookmarks (&x)', 'BookmarkClearAll'])
noremap <silent><nowait>m :call quickui#context#open(bookmarkMenu, bookmarkOpt)<cr>

hi BookmarkSign ctermbg=NONE ctermfg=red guibg=NONE guifg=#ea6962
hi BookmarkLine ctermbg=3 ctermfg=NONE guibg=#343434 guifg=NONE
