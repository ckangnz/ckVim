# JSON WEB TOKENS

```bash
npm install jsonwebtoken
yarn ad jsonwebtoken
```
```js
const jwt = require('jsonwebtoken');

const userID = '1000'; //user id
const secret = 'supersecret'

const token = jwt.sign(userID, secret);
const decodeToken = jwt.verify(token,secret); //decodedToken is the user's id

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

# Login (Token Generation)
#### Create a token when authenticated (LOGIN SUCCESS)
* Generates token and returns user with token
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
* Save user's token to cookie
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

# Authenticated Routes (Token check)
### Install cookie-parser
* We need Cookie Parser to handle our cookies
```bash
npm install cookie-parser
yarn add cookie-parser
```
```js
const cookieParser = require('cookie-parser');
app.use(cookieParser());
```

### Create a static method on schema 
* Find user with matching token from the cookie
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

## Creating a middleware
  * Find user by token from cookie. If exists, pass user and token
```js
// server/middleware/auth.js
const { User  } = require('../models/users');

let auth = (req,res,next) =>{
    let token = req.cookies.auth;

    User.findByToken(token,(err,user)=>{
        if(err) throw err;
        if(!user) res.status(401).send('no access');

        req.token = token;
        req.user = user;
        next();
    })
}

module.exports = {auth}
```

### Add authentication middleware 
```js
//server.js
...
const auth = require('./middleware/auth.js');
...
app.get('/api/user/profile', auth, (req,res)=>{
    res.status(200).send(req.token);
})
```

# Logout
  * Delete token method
```js
userSchema.methods.deleteToken = function(token,cb){
    var user = this;
    user.update({$unset:{token:1}},(err,user)=>{
        if(err) return cb(err);
        cb(null,user);
    })
}
```
 ```js
// Auth middleware will pass user
app.get('/api/logout',auth , (req,res)=>{
    req.user.deleteToken(req.token, (err,user)=>{
        if(err) return res.status(400).send(err);
        res.cookie('auth','').sendStatus(200)
    })
})
 ```
