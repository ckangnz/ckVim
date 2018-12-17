# Props

* A state passed from different component.

```js
// index.js
import TextBox from './component/textbox'

class App extends Component {

  state = {
    sayingHi : 'Hi',
    satingBye : 'Bye',
  }

  render() {
    return <TextBox s={this.state.sayingHi} b={this.state.sayingBye}/>
  }

}

//textbox.js
const TextBox = (props) => {
  return (
    <div>{props.s}</div>
  )
}
```

* props.children

```js

<TextBox>
  Hello :D
</TextBox>

//In textbox.js
const TextBox(props){
  {props.children} //will return Hello :D
}
```
