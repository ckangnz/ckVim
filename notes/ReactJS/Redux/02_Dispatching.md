# Dispatch
 - There are two ways to dispatch ( to trigger an action )

```js
import { movieslist, directorslist } from './actions';

… App …
componentWillMount() {
  this.props.getMovies();
  this.props.getDirectors();
}
… 

const mapDispatchToProps = (dispatch)=>{
  return {
      getMovies: ()=>{
         dispatch(movieslist())
      }
      getDirectors: ()=>{
         dispatch(directorslist())
      }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(App);
```

```js
import { bindActionCreators } from 'redux';

… App …
componentWillMount() {
  this.props.movieslist()
  this.props.directorslist()
}
… 

const mapDispatchToProps = (dispatch)=>{
  return {
    getMovies : bindActionCreators(movielist, dispatch),
    getDirectors : bindActionCreators(directorslist, dispatch),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(App);
```
