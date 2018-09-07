# Requirement
```bash
  npm install -g create-react-app
```

## Terminology
* props : Property that has passed down from when calling component
* state : State from constructor

## Basic structure
```javascript
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

class ComponentName extends React.Component {
  //...methods(){}
  render(){
    return (
        <div>
          <ComponentTwoName className="name" onClick={()=> this.setState({value : 'X'})}/>
        </div>
        )
  }
}

class ComponentTwoname extends React.Component {
    ...
}
```

### Constructor
```javascript
constructor(props){
  super(props);
  this.state = {
    value : null,
    value2 : null,
  }
}
```

### Render
```javascript
ReactDOM.render( <ComponentName />, documentgetElementById('root'))
```
