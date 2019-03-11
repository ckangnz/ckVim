# Creating server and routing with Express JS
  - Install Express

```bash
npm init
yarn init

npm install express
yarn add express
```

```js
const express = require('express');
const fs = require('fs');

const app = express(); //Creating a server

//Render HTML
app.get('/',(req,res)=>{
  let HTML= fs.readfileSync('./index.html')
  res.send(`${HTML}`)
})

//Render JSON
app.get('/json',(req,res)=>{
  let json = {
    name:'Chris',
    lastname:'Kang'
  }
  res.send(json)
})

//Parameter
app.get('/api/user/:id/:whatever',(req,res)=>{
  let id = req.params.id
  let whatever = req.params.whatever
  res.send(json)
})

//Query
//require('querystring')
app.get('/api/car',(req,res)=>{
  let brand = req.query.id;
  let year = req.query.year;
  res.send({
    brand, year,
  })
})

app.listen(8181);
```

### Template Engine

#### EJS
```bash
npm install ejs
yarn add ejs
```
```js
let express = require('express');
let app = express();

app.set('view engine', 'ejs');
app.get('/', (req,res) => {
  // views/index.ejs
  res.render('index', {name : "Chris"});
})

app.listen(8080, () => console.log('Server running at 8080'));
```

* Variable / Loop
```ejs
<!--/views/index.ejs-->
<%= name %>
<% for(var i = 0; i < array.length; i ++ ){ %>
  <%= array[i] %>
<% } %>
```

#### Handlebars
```bash
npm install express-handlebars
yarn add express-handlebars
```
```js
let express = require('express');
let app = express();

const exphbs = require('express-handlebars');
app.engine('.hbs', exphbs({
  defaultLayout: 'main',
  extname:'.hbs'
}))
app.set('view engine', '.hbs');
app.get('/', (req,res) => {
    // views/index.hbs && views/layouts/main.hbs
    res.render('index', {name : "Chris"});
})

app.listen(8080, () => console.log('Server running at 8080'));
```

* Variable / Loops
```html
<!--/views/layouts/index.hbs-->
<body>
  {{{body}}}
</body>
</html>
```
* Variable / Loops
```hbs
<!--/views/index.hbs-->
{{ name }}
{{#each array}}
  {{ this }}
{{/each}}
```

#### Nunjucks
```bash
npm install nunjucks
yarn add nunjucks
```
```js
const express = require('express');
const nunjucks = require('nunjucks');

const app = express();
app.set('view engine', 'html');

//nunjucks.configure('views', {
nunjucks.configure(path.join(__dirname, 'templates'), {
  autoescape:true,
  noCache: (process.env.ENV == 'production')?false:true,
  express:app,
})

app.get('/', (req,res)=>{
  res.render('index.html', {name : "Chris"})
})
app.listen(3000, ()=> console.log('Server is runing at port 3000'))
```

```jinja
<!-- templates/base.html -->
<body>
{% block header %}
  This is default header
{% endblock %}
{% block contents %}
  This is default contents
{% endblock %}
</body>

<!-- templates/index.html -->
{% extends "base.html" %}
{% block header %}
  This is header from index
{% endblock %}
{% block contents %}
  This is contents from index
{% endblock %}
```
* Variable / Loops
```jinja
{{ name }}
{% for item in items %}
  {{item}}
{% endfor %}
```
