# High Order Components


### Basic HOC

```js
const Child = (props) => {
  render (
     <div>
       {props.children}
     </div>
  )
}

const Parent = (props) => {
  return (
      <Child>
        <OtherComponent/>
      </Child>
    )
}
```

### Complex HOC

```js
const parentHoc = (WrappedComp, arg1) => {
  return (props) => {
    <div>
      {args}
      <WrappedComp {...props}/>
    </div>
  }
}

const Parent = () => {
  return (
    <div> Hello World </div>
  )
}

export default parentHoc(Parent, 'hello')
```
