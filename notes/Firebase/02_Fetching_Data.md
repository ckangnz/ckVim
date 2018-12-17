# Fetching a data

* You can use `once('value')` to grab a data only for once.

```js
firebaseDB.ref().once('value')
    .then((snapshot)=>{
        console.log(snapshot.val());
    })
firebaseDB.ref('name').once('value')
    .then((snapshot)=>{
        console.log(snapshot.val());
    })
```

* You can also use `on('value',callback)`
* This method is a real-time, which will get data again if there is a change.

```js
// 'value' , 'child_removed', 'child_updated', 'child_added'
firebaseDB.ref().on('value',(snapshot)=>{
    //console.log(snapshot.key, snapshot.val());
    console.log(snapshot.val());
})
```

* You can turn off the callback by :

```js
firebaseDB.ref().off();
```

### To retrieve this data as an array :

```js
firebaseDB.ref('users').once('value')
    .then((snapshot)=>{
        const data = [];

        snapshot.forEach((childSnapshot)=>{
            data.push({
                id : childSnapshot.key,
                ...childSnapshot.val()
            })
        })
        this.setState(
          data,
        )
    })
```

##### You could store this as a separate function and reuse:

```js
const Looper = (data) => {
  const data = [];

  snapshot.forEach((childSnapshot)=>{
      data.push({
        id : childSnapshot.key,
        ...childSnapshot.val()
    })
  })
  return data;
}
```
