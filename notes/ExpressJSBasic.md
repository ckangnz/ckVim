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
