# Action Creators & Reducers
 - Action Creators returns an object { type , payload }
 - The object is sent to Reducers
 - Reducer updates the Redux State matching the type name

## 1. Create a reducer (e.g. `/src/reducers/movies_reducer.js`)
```js
export default ( state = {} , action )=>{
  switch(action.type){
    case 'MOVIES_LIST':
      return {
        ...state,
        movies: action.payload
      }
    case 'OTHERS_LIST':
      return {
        ...state,
        others: action.payload
      }
    case 'OTHERS_LIST2':
      return {
        ...state,
        others2: action.payload
      }
    default:
      return state;
  }
}
```

## 2. Create a `rootReducer` in `/src/reducers/index.js`
 - This will combine all reducers in one
```js
import { combineReducers } from 'redux';
import movies from './movies_reducer'

const rootReducer = combineReducers({
  movies,
})

export default rootReducer;
```

## 3. Import the `rootReducer` and pass it to createStore
```js
import reducer from './reducers'
...
<Provider store={createStoreWithMiddleware(reducer)}>
...
```

## 4. Create an Action Creator `/src/actions/index.js`
   - This will have list of functions
   - Each function should always return an object with type and payload
```js
export const movieslist = () =>{
  //fetch query
  //must return type: payload:

  //dummy data for e.g.
  return {
      type:'MOVIES_LIST',
       payload: [
         {id:  1,  name:  'Jurassic World'},
         {id:  2,  name:  'Transformer'},
         {id:  3,  name:  'Avengers'},
       ]
  }
}
export const otherlist=()=>{...type:'OTHER_LIST'}
export const otherlist2=()=>{...type:'OTHER_LIST2'}
```

# Connecting Reducers and Action Creators
 - connect(arg1, arg2)
   - arg1 = mapStateToProps
   - arg2 = actions
```js
import { connect } from 'react';
import * as actions from './actions'

//…ComponentName…

const mapStateToProps = (state)=>{
  return {
    data: state.movies,
  }
}

export default connect(mapStateToProps, actions)(ComponentName)
```

### Update the state by calling the action
```js
…
componentDidMount(){
  this.props.movieslist()
  // runs movieslist()
  // reducer fetches the data => checks type => returns new state => components gets new props
}
```
