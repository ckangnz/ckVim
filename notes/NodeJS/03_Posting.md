# Posting with Express

```html
<html>
  <body>
    <h1>Enter new user</h1>
    <form action="/enteruser" method="POST">
      <label for="firstname">First Name</label>
      <input type="text" name="firstname" id="firstname">
      <label for="lastname">Last Name</label>
      <input type="text" name="lastname" id="lastname">
      <input type="submit" value="Submit">
    </form>
  </body>
</html>
```

```js
const bodyParser = require('body-parser');
const fs = require ('fs');
//urlencodeParser expects a querystring
const urlencodeParser = bodyParser.urlencoded({extended:false})
//json parser expects a json
const jsonParser = bodyParser.json();

app.get('/user',(req,res)=>{
  let HTML = fs.readFileSync(`${__dirname}/index.html`)
  res.send(${HTML})
})
app.post('/enteruser',urlencodeParser,(req,res)=>{
  const firstname = req.body.firstname
  const lastname = req.body.lastname
  console.log([firstname,lastname])
  res.send(200)
})
app.post('/enteruser_json',jsonParser,(req,res)=>{
  console.log(req.body)
  res.send(200)
})
```
