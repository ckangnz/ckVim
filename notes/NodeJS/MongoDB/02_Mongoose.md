# Install Mongoose

* Mongoose : MongoDB ODM (Object Data Modeling) library
* Mongodb : Native driver in Node.js to interact with MongoDB.

```bash
npm install mongoose
yarn add mongoose
```

# Connect
```js
const mongoose = require('mongoose');

// Must run mongod first
// By default port is 27017, hence could just write "mongodb://localhost/db_name"
mongoose.connect('mongodb://localhost:27017/test', {useNewUrlParser:true}, (err,res)=>{
    if(err) return console.log(`There was an error : ${err}`);
});

let db = mongoose.connection;
db.once('open', ()=>{
  console.log(`Connected to MongoDB`)
})
```

# Schema and Model
* Mongoose works with Schema
* Schema works with Model.

```js
const carSchema = mongoose.Schema({
    brand: String,
    model: {
      type: String,
      required: true
    },
    year: Number,
    avail: Boolean
})

const Car = mongoose.model('Car',carSchema);
module.exports = Car;
```

# Adding Data
```js
const addCar = new Car({
    brand: "Ford",
    model: "Focus",
    year: 2017,
    avail: true
});

addCar.save((err,doc)=>{
    if(err) return console.log(err);
    console.log(doc)
})
```

# Finding Data
```js
//find, findById, findOne
Car.find({brand:"Ford"},(err,doc)=>{
    if(err) return console.log(err);
    console.log(doc);
})
```

# Deleting Data
```js
//findOneAndRemove, findByIdAndRemove, remove

Car.findOneAndRemove({brand:'Ford'},(err,doc)=>{
  if(err) return console.log(err);
  console.log(doc);
})
Car.findByIdAndRemove('xxx',(err,doc)=>{
  if(err) return console.log(err);
  console.log(doc);
})
Car.remove({year:2000},(err,doc)=>{
  if(err) return console.log(err);
  console.log(doc);
})

```

# Updating Data
```js
//update , findByIdAndUpdate
Car.update(
    {_id:"xxx"}
    ,{ $set:{
      brand:"Nissan"
    }
    },(err,doc){
      //...
})

Car.findById("xxx",(err, car)=>{
  if(err) return console.log(err);

  car.set(){
      brand:"Porche"
  };
  car.save((err, doc)=>{
    if(err) return console.log(err);
    console.log(doc);
  });
})
```
