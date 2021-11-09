### Vinegar(Netrw) File Management Tips

    F1                              Help
    I                               info box at the top
    v                               Open on right pane
    o                               Open on below pane
    i                               toggle different folder structure view
    r                               reorder
    s                               change structure
    x                               open in finder
    %                               create a file
    d                               create a folder
    <Shift> + R                       Rename
    D                               delete file
    mt                              Mark a directory
    mf                              Mark a file
    mU                              Unmark all marked files
    cmc / cmm                       Copy/Move file
    gh                              Toggle hidden files
    . / !                           Action in CLI
    ~                               Go to Root
    :Explore/Sexplore/Vexplore      To Explore in Netrw without Vinegar

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
    ,q                              delete hidden buffers

### General Visual Mode

    //                              search visually selected word
    U / u                           change upper/lowercase (in visual mode only)

### Panes / Buffers

    ctrl+hjkl                       move cursors from buffer to buffer
    ,ww                             swap buffer
    ,wf                             maximize pane
    ,wm                             minimize pane
    ,wh                             change to horizontal split
    ,wv                             change to vertical split
    ,wt                             open to a new tab

### Vim-easymotion

    F                               Type two characters to jump position on screen

### Folding

    zf                              create folds
    za                              toggle folds
    zd                              delete folds
    zr                              open all folds
    zM                              close all folds
    ze                              reset folds

### Vim-surround

    shift + s                       Surround with...(visual mode)
    c + s + ' + "                   change surrounding ' to "

### FZF Plugin

    ctrl + p                        open files
    ctrl + e                        open from history
    ctrl + t                        look for tags

### Search and change:

    ,f (Ack)                        Search all project
    ,F                              Search the word on cursor in all project
    ,h (Gsearch)                    Replace all project
    R                               Rename a variable
    cgn =>  . / n                   Change word => Repeat / Skip
    :s/old/new/g                    Change word old to new
    :s/from.*end/new/               Change word old to new
    :s/id=".\{-}"                   Change `id="*****"`
    :s/id="\v\zs.{-}\ze"            Change id="`*****`"
    ctrl+f f                        Search all project (ctrlsf)
    ctrl+f t                        Reopen search view
    shift+m                         Edit mode for ctrlsf

### Commenting (NerdCommenter)

    ,c<space>                       comment toggle
    ,cy                             comment and yank
    ,ca                             change commenting method
    ,ci                             comment invert
    ,cs                             sexy commenting

### Vim Fugitive + Merginal + GV

    ,1                              Gstatus
        cc                              commit
        ca                              commit --amend
        ce                              commit --amend-noedit
    ,2                              GV (Show logs)
    ,3                              Merginal (Show branches)
        ?                               Help to see more...
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
    ,gL                             Glog (Show log of current file)
    ,gfo                            git fetch origin ??:??
    ,gfa                            git fetch --all --prune

### Open Browser

    ,go.                            Open Git repo
    ,goi                            Open Issues
    ,gop                            Open Pull Reqs
    ,gor                            Create PR

### Emmet Control

    c-y,                            for tags
    c-yd                            for inward
    c-yD                            for Outward
    c-yn                            for Edit Next Point
    c-yN                            for Edit Previous Point
    c-yi                            for Image Edit
    c-ym                            for Merge line
    c-yk                            for Remove Tag
    c-y/                            toggle comment
    c-ya                            Make anchor tag

### Test

#### Jest

    ,tt                             Test nearest function
    ,tf                             Test current file
    ,ts                             Test all suite
    ,tl                             Test last
    ,tL                             Test visited

#### Cypress

    ,to                             Open Cypress with nearest cypress.json

### Vim Bookmark

    ma                             Show all bookmarks
    mm                             Bookmark current line
    mx                             Clear All bookmarks

### Undotree

    ,u                              Show undo tree
    ?                               Hotkeys

### Javascript Syntax Concealing

    ,l                              toggle conceal

### CTags

    ,ct                             Create Ctags

### Vim Instant Markdown

    ,md                             View markdown on browser

### Tabular

    ,ta                             :Tabularize e.g. (,ta=  will prettify =)

### Docker commands

    ,di                             Docker image list
      /                                 Filter image
      r                                 Run image
        -d (detached)
        -p 1234:80 (expose 1234 to 80)
        --rm (remove when stopped)
      R                                 Refresh image
      t                                 Tag image
      s                                 Save image to tarball
      l                                 Load image from tarball
      <CR>                              Inspect Image
    ,dc                             Docker container list
      /                                 Filter container
      u                                 Start container
      s                                 Stop container
      r                                 Restart container
      R                                 Refresh container
      K                                 Kill container
      a                                 Attach container (interactive)
      m                                 Show Monitor CPU/Mem usage
      l                                 Monitor container logs
      ctrl-d                            Delete container
      ctrl-r                            Rename container
      p                                 Switch to image popup window
      c                                 Copy file/folders between container and local file system
      C                                 Create a new image from container
      <CR>                              Inspect a container
