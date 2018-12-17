# State

* Object that serves like a database
* Controls how application behaves
* Re-renders when state changes
* If the module does not require state, try to use functional module instead of class

```js
class Header extends Component {

  constructor(props){
    super(props)
      this.state = {
        keywords:'',
      }
  }
  
  //or

  state = {
    keywords: '',
  }

  inputTextHandler = (event) => {
    this.setState({
      keyword : event.target.value,
    })
  }

  render(){
    return (
          <header>
              <div className="logo" onClick={this.logoClickHandler} >Logo</div>
              <input type="text" onChange={this.inputTextHandler}/>
          </header>
    )
  }
}
```
