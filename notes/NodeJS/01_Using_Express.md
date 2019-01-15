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
const app = express(); //Creating a server

let HTML= fs.readfileSync('./index.html')
let json = {
  name:'Chris',
  lastname:'Kang'
}

app.get('/',(req,res)=>{
  res.send(HTML)
})
app.get('/json',(req,res)=>{
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
