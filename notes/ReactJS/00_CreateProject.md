# ReactJS

## Install create-react-app globally using npm

```bash
npm create-react-app .
npm init react-app .
yarn create react-app .
```

### Basic of ReactJS

- index.js

```js
import React from 'react'; //Always need to be imported
import ReactDOM from 'react-dom'; //Only needed to 'render'
import Header from './components/header'; //Importing components

//Functional Componenet
const App = () => {
  //return React.createElement('h1',{className:'title'}, 'Hello World!')
  return <Header />;
};

//Class Based Component
class App extends React.Component {
  render() {
    return <Header />;
  }
}

ReactDOM.render(<App />, document.getElementById('root'));
```

- components/header.js

```js
// if you import React,{Component} from 'react', you can write :
// class Header extends Componenet {}
import React, { Componenet } from 'react';

class Header extends Component {
  render() {
    return <div>Header</div>;
  }
}

export default Header;
```

### Basic Dynamic Data

```js
return <div> { 5  +  5 } </div>;
//returns 10
return <div> { const a = 1; return 1 + a; } </div>;
//returns error. Needs to have one statement.
return <div> { calculate() } </div>;
//create a function or object to handle the data outside;
```
