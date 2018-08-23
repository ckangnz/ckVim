# General
    tabs are changed = gt / closed = command + w
    nerdtree enabled by ,1
    shift + s = Surround with...
    c + s + ' + " = change surrounding ' to "
    ctrl + y + k = remove tag
    U / u change upper/lowercase (in visual mode only)
    ctrl + a / x increments number
    ctrl x + ctrl + f to insert path

# Navigation on vim
    hjkl = left down up right
    ctrl + e / y scrolling
    ctrl + d / u skipping 
    '' or `` prev cursor point
    gg / G = top / bottom of page
    zz focus cursor in the center
    Ctrl+] takes to wherever the original function is (must have ctags)
    CMD or Ctrl + P for opening files
    // search visually selected word

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
    gh to toggle hidden files
    . or ! to put in the cli
    ~ to go home

# UltiSnippets  + YCM
    tab to autocomplete
    c-j / c-k to jump trigger

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

### PERSONAL
# EXPRESS NODE VIEWS
pp - package.json
na - app.js
nc - config.js
nv - views
nc - styles
nj - js

# Starting Express Project
npm init
npm install nodemon - package.json > script : devstart "nodemon ./bin/www"
npm install 
    express
    ejs
    ejs-locals
    body-parser 
    cookie-parser
    node-sass-middleware
    mongoose
    morgan
    async
    passport, connect-flash, bcrypt-nodejs, express-session

### Optional-npm install mysql
    -Using MySql
    var my sql = require('mysql');
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "",
        database: "TemplateDatabase"
    })
    con.query("SELECT * from Page", function(err, rows){
        if(err)throw err;
        console.log(rows);
    });
