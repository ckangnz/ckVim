# Adding styles

### Inline styling

```js
class Header extends Component{
  state = {
    active : false
  }
  render(){
      const styles = {
          header: {
              background: '#03a9f4'
              fontFamily:'monospace',
              textAlign:'center',
          },
          logo : {
              color:'#fff',
          }
      }
      return (
          <header style={styles.header}>
              <div style={{color : "#fff"}}>Logo</div>
              <div style={{color : `${this.state.active ?"white":"yellow"}`, }}>Logo</div>
              <input type="text"/>
          </header>
      )
  }
}
```

### CSS file

* Create `src/css/styles.css`

```
import '../css/styles.css'
...
return <div className="class_name"></div>
```

* or you could import css as a module

```js
import xxx from '../css/styles.module.css'
...
return <div className={xxx.class_name}></div> )
```

### Glamor

```bash
npm install glamor --save
```

```js
import {css} from 'glamor';

const Item = () => {
  let button = css({
    border:'1px solid white',
  })
  let button_red = css({
    padding: '10px 20px',
    backgroundColor: 'red',
  })

  //return <div {...button} {...button_red} ></div> )
  //or
  //return <div className={`${button} ${button_red}`} ></div> )
}
```

