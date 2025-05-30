### Oil.nvim Tips

    g?                              help
    -                               Navigate to the parent path
    ~                               to the current working directory
    cd                              :cd to the current oil directory
    tcd                             :tcd to the current oil directory
    gt                              Open in a new tab
    gd                              Open in a horizontal split
    gv                              Open  in a vertical split
    gx                              Open in an external program
    gh                              Toggle hidden files and directories
    gs                              Change the sort order
    !                               Open vim cmdline with current entry as an argument
    gy                              Yank the filepath of current entry to a register
    <C-/>                           Open  in a preview window, or close the preview window if already open
    <C-c>                           Close oil and restore original buffer
    <C-r>                           Refresh current directory list
    <CR>                            Open
    :Explore/Sexplore/Vexplore      to Explore in Netrw without Vinegar

### General Normal Mode

    hjkl                            left down up right
    gg / G                          top / bottom of page
    ctrl + u / d                    jump half page up / down
    ctrl+ o / i                     jump to previous cursor position in files
    ''                              last position of cursor
    zz                              focus cursor in the center
    ctrl+] / :pop                   jump to ctag / out of ctag
    gt / gT                         change tabs
    :vsp / :sp                      split view vertical/horizontal
    ctrl + a / x                    increments number
    ctrl x + ctrl + f               insert directory path
    ,q                              delete hidden buffers (Asheq/close-buffers.vim)

### Panes / Buffers

    ctrl+hjkl                       move cursors from buffer to buffer
    ,ww                             swap buffer (wesQ3/vim-windowswap)
    ,wf                             maximize pane
    ,wm                             minimize pane
    ,wh                             change to horizontal split
    ,wv                             change to vertical split
    ,wt                             open to a new tab

### Vim-easymotion

    F                               type two characters to jump position on screen

### Folding

    <space>                         toggle fold
    zR                              open all folds
    zr                              increment open fold
    zM                              close all folds
    zm                              decrement close fold

### Vim-Sandwich

    shift + s                       surround with...(visual mode)
    c + s + ' + "                   change surrounding ' to "
    c + a + '                       change words in '' including '
    c + i + '                       change words in '' excluding '
    ysiw'                           surround current word with '

### Telescope Plugin

    ctrl + p                        find files
    ctrl + e                        open from history
    ?                               find variables/functions

### Search and change:

    ,f (Rg)                         search all project
    ,F                              search the word on cursor in all project
    ,h                              search and replace using CocSearch
    R                               rename a variable
    cgn =>  . / n                   change word => Repeat / Skip
    :s/old/new/g                    change word old to new
    :s/from.*end/new/               change word old to new
    :s/id=".\{-}"                   change `id="*****"`
    :s/id="\v\zs.{-}\ze"            change id="`*****`"

### Commenting (NerdCommenter)

    ,c<space>                       comment toggle
    ,cy                             comment and yank
    ,ca                             change commenting method
    ,ci                             comment invert
    ,cs                             sexy commenting

### Vim Fugitive + GV

    ,1                              Gstatus
        cc                              commit
        ca                              commit --amend
        ce                              commit --amend-noedit
    ,2                              GV -all(Show all log history)
    ,@                              GV!(Show log of current file)
    ,3                              Telescope git_branches (Show branches)
        <cr>                        Checkout branch
        <C-t>                       Track branch
        <C-r>                       Rebase branch
        <C-a>                       Add branch
        <C-s>                       Switch branch
        <C-d>                       Delete branch
        <C-y>                       Merge branch
    ,gp                             Push
    ,gP                             Push Force
    ,gl                             Pull
    ,gr                             Gread
    ,gw                             Gwrite
    ,gd                             Gdiff   (Diff local / index)
      do                                diff obtain(bring)
      dp                                diff put(revert)
    ,gD                             Gdiffsplit (3 splits for conflicts)
    ,ge                             Gedit   (Toggle local / index)
    ,gb                             Gblame (Show blame for current file)
    ,gfo                            git fetch origin ??:??
    ,gfa                            git fetch --all --prune
