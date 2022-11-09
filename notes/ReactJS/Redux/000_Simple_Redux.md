# Redux

- Install Redux in the project

```bash
 npm install redux
 yarn add redux
```

# Store

- Import `createStore` from redux
- `createStore` takes `reducer` as an argument

```js
import { createStore } from "redux";

//const store = createStore(reducer, initialState)
const store = createStore(reducer);
```

- store can be used like so :

```js
store.getState(); // gets the state in redux store
store.subscribe(arg); // re-renders argument
store.dispatch(someAction); // dispatch an action
```

- A simple redux app may use subscribe to re-render when states are updated by dispatching

```js
const render = () => ReactDOM.render(<App />, document.getElementById("root"));
render();
store.subscribe(render);
```

## Reducer

- Reducer is a function that returns a new state object.
- Reducer takes two arguments : state , action
- Reducer usually looks like this :

```js
export default (state = {}, action) => {
  switch (action.type) {
    case "ACTION_NAME":
      return {
        ...state,
        someState: action.payload,
      };
    default:
      return state;
  }
};
```

### Combining Reducers

```js
//reducer/index.js
import { combineReducers } from "redux";
import aReducer from "./aReducer";
import bReducer from "./bReducer";

export default combineReducers({
  stateName: (state, action) => {
    return state;
  },
  aReducer: aReducer,
  bReducer,
});
```

## Action

- Action always returns an object with `type` and `payload`

```js
export const someAction = () => {
  //do some logic
  return {
    type: "ACTION_NAME",
    payload: "whatever-fetched-from-the-logic",
  };
};
```

## Dispatch

- Dispatch takes `action` as an argument

```js
store.dispatch(someAction());
```
