# Containers
 - Component related to redux store == 'Container'
 - Try to import Functional Components to render DOM

```js
// /src/container/app.js
class App extends Component {
  componenetWillMount(){...call dispatch}
  render(){
    return (
      <OtherComponent {...this.props}/>
      <OtherComponent1 {...this.props}/>
      <OtherComponent2 {...this.props}/>
    )
  }
}

// /src/components/othercomponent.js
const OtherComponent = (props) => {
  const renderSomething = (data)=>{
    data
      ? data.map((data,i)=>{
        <div key={i}>{data.name}</div>
      }
      :null;
    )
  }
  return (
      <div>
        {renderSomething(props.data.data)}
      </div>
  )
}
```
