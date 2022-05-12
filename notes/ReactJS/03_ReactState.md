# State

- Object that serves like a database
- Controls how application behaves
- Re-renders when state changes
- If the module does not require state, try to use functional module instead of class

### Functional component

```js
import { useState } from 'react';
const Header = () => {
  const [value, setValue] = useState;

  const inputTextHandler = (event) => {
    setValue([...value, event.target.value]);
  };

  return (
    <header>
      <div className="logo" onClick={logoClickHandler}>
        Logo
      </div>
      <input type="text" value={value} onChange={inputTextHandler} />
    </header>
  );
};
```

### Class based component

```js
class Header extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: '',
    };
  }

  //or

  state = {
    value: '',
  };

  inputTextHandler = (event) => {
    this.setState({
      value: event.target.value,
    });
  };

  render() {
    return (
      <header>
        <div className="logo" onClick={this.logoClickHandler}>
          Logo
        </div>
        <input
          type="text"
          value={this.state.value}
          onChange={this.inputTextHandler}
        />
      </header>
    );
  }
}
```
