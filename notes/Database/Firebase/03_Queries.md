# Queries

```js
// orderByChild('fieldname') 
// limitToFirst(3) get top 3
// limitToLast(3) get last 3
// equalTo(element.id) get matching value


firebaseDB.ref('users').orderByChild('age').once('value')
    .then((snapshot)=>{
        const data = [];

        snapshot.forEach((childSnapshot)=>{
            data.push({
                id : childSnapshot.key,
                ...childSnapshot.val()
            })
        })
        console.log(users);
    })
```
