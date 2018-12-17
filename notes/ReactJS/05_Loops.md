# Looping (ES6)

* Whenever working with the loop/iterator you need to pass a key(id)

```js
const lists = props.listItem.map((i)=>{
    return ( //must return single item
      <li>
        <h3>{i.title}</h3>
      </li>
    )
})

render(){
  return { this.lists }
}
```
