# Redux
 - State Management Library

## Overview
1. Create Redux store with `const store = createStore()`
2. Pass reducer to store `function reducer(state={},action){return {}}` `createStore(reducer)`
  - Reducer decides `initialState` and how the state changes by action names
  - If action is not recognised, state doesn't change
3. Pass down the store with `<Provider store={store}></Provider>`, from `react-redux`
4. Create connectComponent with `react-redux`. 
  - `connect(mapStateToProps,mapDispatchToProps)(CompName)`
5. Create `mapStatestoProps` : `function mapStateToProps(state){return{xxx:state.xxx}}`
6. Create an action : `const actioname = ()=>{return {type:'ACTION_NAME', payload:[{...},{...}]}}`
7. Create `mapDispatchToProps` : `function mapDispatchToProps(dispatch){return bindACtionCreators({ actionname })}`
8. Dispatch with `this.props.actionname()`

> `Dispatch` => `Action returns type and payload` => `Reducer checks type` => `Reducer updates state` => `Provider re-renders component` 

---

### Installing
```bash
npm install redux react-redux
yarn add redux react-redux
```

```js
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';

//const store = createStore(reducer);
//store.getState();

const createStoreWithMiddleware = applyMiddleware()(createStore)

...
//<Provider store={createStore}> //without middleware
<Provider store={createStoreWithMiddleware()}>
    <App/>
</Provider>
...
```
