# JSON WEB TOKENS

```bash
npm install jsonwebtoken
yarn ad jsonwebtoken
```

### Basics

```js
const jwt = require('jsonwebtoken');

const id = '1000'; //user id
const secret = 'supersecret'

const token = jwt.sign(id, secret);
const decodeToken = jwt.verify(token,secret);

console.log(decodeToken)
```

### Add token field on user schema

```js
const userSchema = mongoose.Schema({
    email: {
        type: String,
        required : true,
        trim:true,
        unique: 1
    },
    password: {
        type:String,
        required: true,
        minlength : 6,
    },
    token: {
        type:String,
    }
})
```

### Create generateToken method
```js
userSchema.methods.generateToken = function(cb){
    var user =this;
    var token = jwt.sign(user._id.toHexString(), 'supersecret');

    user.token = token;
    user.save(function(err,user){
        if(err) return cb(err);
        cb(null,user);
    })
}
```

### Generate Token when user succeeds to login

```js
app.post('/api/user/login',(req,res)=>{
    User.findOne({'email':req.body.email}, (err,user)=>{
        if(!user) res.json({message: 'Auth failed, user not found'});
        user.comparePassword(req.body.password, (err,isMatch)=>{
            if(err) throw err;
            if(!isMatch) return res.status(400).json({
                message:"Wrong Password"
            });

            user.generateToken((err,user)=>{
                if(err) return res.status(400).send(err);
                res.cookie('auth',user.token).send('ok');
            });
        })
    })
})
```

### Create a static method on schema 

```js
userSchema.statics.findByToken = function(token, cb){
    const user = this;
    jwt.verify(token,'supersecret',function(err,decode){
        user.findOne({"_id":decode, "token":token}, function(err,user){
            if(err) return cb(err);
            cb(null,user);
        })
    })
}
```

### Make another route and Install cookie-parser
```bash
npm install cookie-parser
yarn add cookie-parser
```
```js
const cookieParser = require('cookie-parser');
//...
app.use(cookieParser());
//...
app.get('/api/user/profile',(req,res)=>{
    let token = req.cookies.auth;

    User.findByToken(token,(err,user)=>{
        if(err) throw err;
        if(!user) res.status(401).send('no access');

        res.status(200).send('you have access');
    })
})
```

---

# Creating a middleware

### Instead of checking cookie from the routes, create a auth.js

```
// server/middleware/auth.js

const { User  } = require('../models/users');

let auth = (req,res,next) =>{
    let token = req.cookies.auth;

    User.findByToken(token,(err,user)=>{
        if(err) throw err;
        if(!user) res.status(401).send('no access');

        req.token = token;
        next();
    })
}

module.exports = {auth}
```

### Simplify the routes 
```js
//server.js
...
const auth = require('./middleware/auth.js');
...
app.get('/api/user/profile',auth, (req,res)=>{
    res.status(200).send(req.token);
})
```
