# Adding data
```js
// if ref() has empty value db will wipe out!
firebaseDB.ref().set({
    name:'Chris',
    lastname:'Kang',
    age:28,
    car:{
        brand:'BMW',
        year:2011,
    }
});

// you can specifically update value using ref
firebaseDB.ref('lastname').set('Richardson');
firebaseDB.ref('car/brand').set('Mercedez');

// you can add value using ref
firebaseDB.ref('skill').set(['Singing','Thinking'])
    .then(()=>{ // This happens when it succeeds
        console.log('db saved')
    })
    .catch((e)=>{ // This happens when it fails
        console.log(e)
    })

// Instead it is possible to push like an array
firebaseDB.ref('users').push({
  name:'Someone',
  lastname:'haha',
})
```

# Remove data

```js
firebaseDB.ref('car/year').remove()
firebaseDB.ref('car/brand').set(null)
```

# Updating data

```js
firebaseDB.ref('car/brand').set('Toyota')
firebaseDB.ref().update({
  'car/brand':'Toyota',
})
```
