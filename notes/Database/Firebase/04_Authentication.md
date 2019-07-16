# Authentication

* To disable public access on the database, we need to disable the rule to false.
* Enable Authentication > Sign-in method Email/Password OR Google Auth
* In `firebase.js`, export these:

```js
import * as firebase from 'firebase';

var config = {...}
const firebaseDB = firebase.database();
const googleAuth = new firebase.auth.GoogleAuthProvider();

export {
    firebase,
    firebaseDB,
    googleAuth,
}
```

### Register (Email and password)

```js
firebase.auth().createUserWithEmailAndPassword( email, password )
  .then(()=>{
    this.props.history.push('/') //redirect user
  })
.catch(error=>{
    // disable loading?
  })
```

### Login and Logout

```js
import { firebase, googleAuth } from './firebase';

//Email and Password
firebase.auth().signInWithEmailAndPassword( email, password )
  .then(()=>{
    this.props.history.push('/') //redirect user
  })

//Google Auth
firebase.auth().signInWithPopup(googleAuth);
firebase.auth().signOut();
```

### Checking current status

```js
firebase.auth().onAuthStateChanged((user)=>{
    if(user){
        console.log('logged in')
    }else {
        console.log('logged out')
    }
})
```
