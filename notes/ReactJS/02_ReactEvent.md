###### React Events

* Inline inject function
```js
class Header extends Component{
  render(){
      return (
          <header>
              <div className="logo"
                  onClick={ ()=>console.log("I was clicked") }
              >Logo</div>
              <input type="text"/>
          </header>
      )
  }
}
```

* function call

```js
class Header extends Component{
  logoClickHandler(){
    console.log("I was clicked")
  }
  inputTextHandler(event){
    event.target.val
  }

  render(){
      return (
          <header>
              <div className="logo" onClick={this.logoClickHandler} >Logo</div>
              <input type="text" onChange={this.inputTextHandler}/>
              <input type="text" onChange={(e)=>this.inputTextHandler(e)}/>
          </header>
      )
  }
}
```
