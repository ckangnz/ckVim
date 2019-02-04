# Install mongodb in your project

```bash
npm install mongodb
yarn add mongodb
```

### Create a server.js
```js
const { MongoClient } = require('mongodb');

//const url = 'mongodb://localhost:27017/test'; //ip:port/database  (mongodb:"^2.2.33")
const url = 'mongodb://localhost:27017/' //ip:port (current)

//MongoClient.connect(url, (err,db)=>{})
MongoClient.connect(url, { useNewUrlParser:true },  (err, client)=>{
  var db = client.db('test');
  if(err){
    console.log('could not connect');
  }
  db.close();
})
```

### Insert a single data ( insertOne )

```js
//server.js
MongoClient.connect(url, { useNewUrlParser:true },  (err, client)=>{
  var db = client.db('test');
  db.collection('Collection_Name').insertOne({
      name:'Chris',
      age:28,
    },(err,res)=>{
      if(err){
        return console.log(`Cannot insert: ${err}`)
      }
      // console.log(res.ops); //returns the object just created
      // console.log(res.ops[0]._id.getTimestamp()); //returns the created time of the object
    })
})
```

### Insert multiple data (insertMany)

```js
MongoClient.connect(url, {useNewUrlParser:true}, (err,client)=>{
    var db = client.db('test');
    const cars = [
        {model:"Chevy", year:2017},
        {model:"Nissan", 2016},
    ]

    db.collection('Collection_Name').insertMany( cars, (err, res)=> {
        if(err){ return console.log(`Cannot insert: ${err}`) }
        console.log(res.ops)
    })
})
```

### Find data ( find )
* .skip(1) : skip first one
* .limit(10) : only show top 10
* .sort({"_id":-1}) : order by latest

```js
MongoClient.connect(url, {useNewUrlParser:true}, (err,client)=>{
    var db = client.db('test');
    db.collection('Collection_Name').find( {year:2017} ).toArray().then(data=>{
        console.log(data);
    })
})
```

### Delete data (deleteMany, deleteOne, findOneAndDelete)
```js
MongoClient.connect(url, {useNewUrlParser:true}, (err,client)=>{
    var db = client.db('test');

    db.collection('Collection_Name').deleteOne({year: 2018},(err, doc)=>{
        console.log(doc);
    })
    db.collection('Collection_Name').deleteMany({year: 2018},(err, doc)=>{
        console.log(doc);
    })
    db.collection('Collection_Name').findOneAndDelete({year: 2018},(err, doc)=>{
        console.log(doc);
    })
})
```

### Update (findOneAndUpdate)
* $set : Sets the value of a field in a docuement
* $inc : Increase the value in a field
* $rename : Renames a field
* $unset : Removes the specified field from a document
* read `update operators` for more info

```js
MongoClient.connect(url, {useNewUrlParser:true}, (err,client)=>{
    var db = client.db('test');

    db.collection('Collection_Name').findOneAndUpdate(
        { name: "Chris" },
        { $set:{
            lastname:"Kong"
        }},
        {
          upsert : false, //create new doc if not found
          returnOriginal:false 
        },
        (err,doc)=>{
            console.log(doc);
        }
    )
})
```

