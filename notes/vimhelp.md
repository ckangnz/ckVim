# General
    tabs are changed = gt / closed = :q
    Visual Mode: shift + s = Surround with...
    Normal Moade: c + s + ' + " = change surrounding ' to "
    U / u change upper/lowercase (in visual mode only)
    ctrl + a / x increments number
    ctrl x + ctrl + f to insert path

# Navigation on vim
    hjkl = left down up right
    ctrl + e / y scrolling
    ctrl + d / u skipping 
    ''  prev cursor point
    gg / G = top / bottom of page
    zz focus cursor in the center
    Ctrl + p for opening files
    Ctrl + e for opening from buffer/memories
    Ctrl + t for looking for function
    // search visually selected word
    Ctrl+] takes to wherever the original function is (must have ctags)
    Normal Mode: Ctrl+O / Ctrl+ I jump to previous cursor position

# Panes / Buffers
    Navigate panes with ctrl+hjkl / closed = :q OR cmd+w
    :vsp & :sp for splitting
    ,ww ,ww to copy swap pane
    ,wf maximize pane
    ,wm minimize pane
    ,,p ,,n changing buffer

# Commenting (NerdCommenter)
    ,c<space>   comment toggle
    ,cy         comment and yank
    ,ca         change commenting method 
    ,ci         comment invert
    ,cs         sexy commenting

# Folding
    za toggle folds
    zd delete folds
    zf setting folds
    zr open all folds
    zM close all folds
    ze reset folds

# Search and change: 
    ,f (Ag) Search all project
    ,h (Gsearch) Replace all project
        - cgn on the word => change the word => .(change next word) or n(skip)
    OR (in Visual Mode):s/from-this-word/to-this-word

# Vinegar File Management Tips
    F1 = Help
    I = info box at the top
    v = Open on right pane"
    o = Open on below pane"
    i = toggle different folder structure view"
    r = reorder
    s = change structure
    x = open in finder
    % create a file
    d create a folder
    Shift + R = Rename
    D delete file

    mt Mark a directory
    mf Mark a file
    mU Unmark all marked files  
    (c)mc / mm Copy/Move file

    gh to toggle hidden files
    . or ! to put in the cli
    ~ to go home

# UltiSnippets  + YCM
    tab to autocomplete
    c-j / c-k to jump trigger

# Vim Fugitive + Merginal + GV
    ,gst    Gstatus
    ,gr     Gread
    ,gw     Gwrite
    ,gd     Gdiff   (Diff local / index)
    ,ge     Gedit   (Toggle local / index)
    ,gb     :Merginal (Show branches)
    ,gB     :Gblame (Show blame for current file)
    ,gl     :GV (Show logs)
    ,gL     :Glog (Show log of current file)

# Tabular
    ,ta     :Tabularize e.g. (,ta=  will prettify =)

### Emmet Control
    c-y, for tags
    c-yd for inward
    c-yD for Outward
    c-yn for Edit Next Point
    c-yN for Edit Previous Point
    c-yi for Image Edit
    c-ym for Merge line
    c-yk for Remove Tag
    c-y/ toggle comment
    c-ya Make anchor tag
