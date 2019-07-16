# Firebase

## General knowledge
* MySQL = tables
* MongoDB = collections
* Firebase = references
* Firebase does NOT support arrays

### Setup online
* Login from firebase.google.com
* Create a project
* Make sure the database rule has read/write permission
* From `Project Overview`, grab a snippet for a web app

```js
 //Example
 var config = {
    apiKey: "",
    authDomain: "",
    databaseURL: "",
    projectId: "",
    storageBucket: "",
    messagingSenderId: ""
  };
  firebase.initializeApp(config);
```

### Install firebase package in a project

```bash
npm install firebase --save
yarn add firebase
```

### Create `firebase.js`

```js
import * as firebase from 'firebase';

var config = {
  ...
};

firebase.initializeApp(config);
// Try code below to check if the database is connected
//firebase.database().ref().set('it works');
```
