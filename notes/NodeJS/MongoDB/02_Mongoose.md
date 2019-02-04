# Install Mongoose
```bash
npm install mongoose
yarn add mongoose
```

# Connect
```js
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/test', {useNewUrlParser:true}, (err,res)=>{
    if(err) return console.log(`There was an error : ${err}`);
});
```

# Schema and Model
* Mongoose works with Schema
* Schema works with Model.

```js
const carSchema = mongoose.Schema({
    brand: String,
    model: String,
    year: Number,
    avail: Boolean
})

const Car = mongoose.model('Car',carSchema);

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
