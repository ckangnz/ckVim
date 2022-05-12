# Props

- A state passed from different component.

### Functional component

```js
const TextBox = (props) => {
  return <div>{props.s}</div>;
};
```

### Class based component

```js
// index.js
import TextBox from './component/textbox';

class App extends Component {
  state = {
    sayingHi: 'Hi',
    satingBye: 'Bye',
  };

  render() {
    return <TextBox s={this.state.sayingHi} b={this.state.sayingBye} />;
  }
}
```

- props.children

```js

<TextBox>
  Hello :D
</TextBox>

//In textbox.js
const TextBox(props){
  {props.children} //will return Hello :D
}
```
