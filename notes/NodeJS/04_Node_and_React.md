# Connecting Node and React

Install following first :
```bash
yarn init #npm init
yarn add express #npm install express
yarn add concurrently #npm install concurrently
```

```js
//server.js

const express = require('express');
const app = express();

app.get('/api/user', (req,res)=>{
    res.json([
        { id:1,  username:'Chris' },
        { id:2,  username:'Juhee' },
    ])
})

const port = process.env.PORT || 3001;
app.listen(port);
```

### Create Client-side : 

```bash
npm create-react-app frontend
npm init react-app frontend
yarn create react-app frontend
```

### Organising package.json

```json
// package.json of backend
{
  ...
    "scripts":{
      "start":"node server.js", //This is what heroku reads
      "server":"nodemon server.js",
      "client":"npm run start --prefix frontend",
      "dev": "concurrently \"npm run server\" \"npm run client\""
    }
  ...
}
```

### Connect Front and Back
In `/frontend`, `yarn add http-proxy-middleware`.
```js
//src/setupProxy.js

const proxy = require('http-proxy-middleware');

module.exports = function(app) {
  app.use(proxy('/api/', { target: 'http://localhost:3001' }));
};
```

