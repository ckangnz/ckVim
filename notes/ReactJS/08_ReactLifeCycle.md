# Functions that run before render() in class component

```js
class SomeComponent extends React.Component {
  // 01. Loads Props. (this.props)
  // 02. Loads States (this.state.title)

  // 03. componentWillMount(){ }
  // use for initial state calculations
  // 04. render(){ }
  // 05. componentDidMount(){}
  // use for side-effects (network reqs)

  // When state changes.....
  // 01 componentWillUpdate(){}
  // 02 render(){}
  // 03 componentDidUpdate(){}

  // Checking the next prop/state value before rerender (return boolean)
  shouldComponentUpdate(nextProps, nextState) {
    console.log(this.state);
    console.log(nextState);
    return true;
  }

  // Checking if component is unmounted
  // componentWillUnmout(){}
}
```
