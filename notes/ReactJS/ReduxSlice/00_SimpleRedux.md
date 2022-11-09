# Simple Redux Toolkit

## Install Redux Toolkit and Redux

```bash
npm install react-redux @reduxjs/toolkit
```

## Create Redux Store

```js
//app/store.js

import { configureStore } from "@reduxjs/toolkit";

export default configureStore({
  reducer: {},
});
```

## Provide the Redux Store to React

```js
//src/index.js

import store from "./app/store";
import { Provider } from "react-redux";

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("root"),
);
```

## Create a Redux State Slice

- Create a slice
  - Slice have `initialState` and `reducers`
  - `actions` can be pulled out from the slice

```js
//reducer/reducerSlice.js

import { createSlice } from "@reduxjs/toolkit";

//e.g.postsSlice
export const doSlice = createSlice({
  //e.g. posts
  name: "doSlice",

  initialState: {
    value: 0,
  },

  reducers: {
    doSomething: (state) => {
      state.value += 1;
    },
    doSomethingWithAction: (state, action) => {
      state.value += action.payload;
    },
  },
});

//export actions
//these are dispatched as `dispatch(doSomething())`
export const { doSomething, doSomethingWithAction } = doSlice.actions;

//export custom async actions with argument
//this is used as `dispatch(doSomethingAsync(1))`
export const doSomethingAsync = (argument) => (dispatch, getState) => {
  const stateBefore = getState();
  console.log(`State started from: ${stateBefore.value}`);

  setTimeout(() => {
    dispatch(doSomethingWithAction(argument));
    const stateAfter = getState();
    console.log(`State updated to: ${stateAfter.value}`);
  }, 1000);
};

//export custom async actions without argument
//this is used as `dispatch(doSomethingWithoutArgument())`
export const doSomethingWithoutArgument = (dispatch, getState) => {
  const stateBefore = getState();
  console.log(`State started from: ${stateBefore.value}`);

  setTimeout(() => {
    dispatch(doSomething());
    const stateAfter = getState();
    console.log(`State updated to: ${stateAfter.value}`);
  }, 1000);
};

//export reducers
export default doSlice.reducer;

//export selectors
export const selectState = (state) => state.value;
```

## Add Slice Reducers to the Store

```js
//app/store.js

import { configureStore } from "@reduxjs/toolkit";
import exportedReducer from "reducer/reducerSlice";

export default configureStore({
  reducer: {
    reducerName: exportedReducer,
    // posts: postsReducer,
    // comments: commentsReducer,
    // users: usersReducer,
  },
});
```

## Use Redux State and Actions in React Components

```js
import React from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  doSomething,
  doSomethingWithAction,
  selectState,
} from "reducer/reducerSlice";

export const ComponentName = () => {
  const dispatch = useDispatch();
  const reduxValue = useSelector(selectState);

  return (
    <div>
      {reduxValue}
      <button onClick={() => dispatch(doSomething())}>Click Me</button>
      <button onClick={() => dispatch(doSomethingWithAction(5))}>
        Click Me
      </button>
    </div>
  );
};
```
