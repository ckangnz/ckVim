# Setting up

```bash
//init then:
npm install express mongoose body-parser
yarn add express mongoose body-parser
```

## Running Server
* Run nodemon server/server.js
* Run mongod

```js
// server/server.js

const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();


mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost:27017/auth',{ useNewUrlParser:true })

const port = process.env.PORT || 3000;

app.listen(port, ()=>{
    console.log(`Started on port ${port}`);
});
```

## Create User Schema

```js
// server/models/users.js

const mongoose = require('mongoose');

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
    }
})

const User = mongoose.model('User', userSchema);

module.exports = { User }
```

## Import from server

```js
//...
const { User } = require('./models/users');
app.use(bodyParser.json());

app.post('/api/user', (req,res)=>{
    const user = new User({
        email:req.body.email,
        password: req.body.password
    });
    user.save((err,doc)=>{
        if(err) res.status(400).send(err);
        res.status(200).send(doc);
    });
})
//...
```

## Hashing Password (basics)

```bash
node install bcrypt
yarn add bcrypt
```

```js
const bcrypt = require('bcrypt');
bcrypt.getnSalt(10,(err,salt)=>{
    if(err) return next(err);

    bcrypt.hash('my_password_123', salt , (err.hash)=>{
        if(err) return next(err);
        console.log(hash);
    })
})
```

### Bcrypt in User Schema

```js
//users.js
//...
const bcrypt = require('bcrypt');
const SALT_I = 10;
//...

userSchema.pre('save',function(next){
    var user = this;

    if(user.isModified('password')){
        bcrypt.genSalt(SALT_I, function(err, salt){
            if(err) return next(err);

            bcrypt.hash(user.password, salt, function(err, hash){
                if(err) return next(err);

                user.password = hash;
                next();
            })
        })
    } else {
        next();
    }
})
```

### Authentication
```js
//server.js

app.post('/api/user/login',(req,res)=>{
    User.findOne({'email':req.body.email}, (err,user)=>{
        if(!user) return res.json({message: 'Auth failed, user not found'});
        bcrypt.compare(req.body.password, user.password, (err,isMatch)=>{
            if(err) throw err;
            res.status(200).send(isMatch);
        })
        //res.status(200).send(user)
    })
})

//-----------------------------------------------

// Or store the method in the model
// users.js
userSchema.methods.comparePassword = function(candidatePassword,cb){
    bcrypt.compare(candidatePassword, this.password, function(err,isMatch){
        if(err) return cb(err);
        cb(null, isMatch)
    })
}

// server.js
app.post('/api/user/login',(req,res)=>{
    User.findOne({'email':req.body.email}, (err,user)=>{
        if(!user) res.json({message: 'Auth failed, user not found'});
        user.comparePassword(req.body.password, (err,isMatch)=>{
            if(err) throw err;
            if(!isMatch) return res.status(400).json({
                message:"Wrong Password"
            });
            res.status(200).send(user);
        })
    })
})

```
