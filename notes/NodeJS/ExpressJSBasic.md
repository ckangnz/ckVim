# Starting Express Project
```bash
npm init
npm install 
    nodemon 
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
```
Edit package.json
```bash
...
script : devstart "nodemon ./bin/www"
...
```

### If you want to use MySQL
```bash
npm install mysql
```
```js
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
```
