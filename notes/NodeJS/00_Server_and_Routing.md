# Creating a server with Node

```js
const http = require('http');
const fs = require('fs');

let HTML= fs.readfileSync('./index.html')
let json = {
  name:'Chris',
  lastname:'Kang'
}

const server = http.createServer((req,res)=>{
  res.writeHead(200, {'Content-type':'text/plain'});
  res.end('Hello World')

  //res.writeHead(200, {'Content-type':'text/html'});
  //res.end(HTML)

  //res.writeHead(200, {'Content-type':'application/json'});
  //res.end(JSON.stringify(json))

  //Routing
  if(req.url === '/'){
    res.writeHead(200, {'Content-type':'application/json'});
    res.end(JSON.stringify(json))
  }
})

server.listen(8181, '127.0.0.1');
```

### Correct way for porting

```js
const port = process.env.PORT || 8181;
server.listen(port)
```
