# Redux

## Install Redux and Redux Toolkit

```bash
npm install react-redux @reduxjs/toolkit
yarn add react-redux @reduxjs/toolkit
```

## Store

### Legacy: createStore()

```jsx
import { createStore, applyMiddleware } from "redux";

createStore(reducer);

createStore(reducer, initialState);
createStore(reducer, applyMiddleware(middleware));

createStore(reducer, initialState, applyMiddleware(middleware));
```

> Example

```js
import { createStore, applyMiddleware, combineReducers, compose } from "redux";
import thunk from "redux-thunk";
import createSagaMiddleware from "redux-saga";

import postsReducer from "../reducers/postsReducer";
import usersReducer from "../reducers/usersReducer";

const rootReducer = combineReducers({
  posts: postsReducer,
  users: usersReducer,
});

//thunk
const middlewareEnhancer = applyMiddleware(thunk);
//saga
const middlewareEnhancer = applyMiddleware(createSagaMiddleware());

const composeWithDevTools =
  window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const composedEnhancers = composeWithDevTools(middlewareEnhancer);

const store = createStore(rootReducer, composedEnhancers);

//saga only. Supply watcher saga
sagaMiddleware.run(watcherSaga);

<Provider store={store}>
  <App />
</Provider>;
```

### Modernised: configureStore() from '@reduxjs/toolkit'

```jsx
import { configureStore } from "@reduxjs/toolkit";

configureStore({
  reducer: rootReducer,
});
configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(logger, saga, api.middleware),
});
configureStore({
  reducer: rootReducer,
  middleware: new Tuple(saga, logger),
});
```

> Example

```
import { configureStore } from '@reduxjs/toolkit'

import postsReducer from '../reducers/postsReducer'
import usersReducer from '../reducers/usersReducer'

// Automatically adds the thunk middleware and the Redux DevTools extension
const store = configureStore({
  // Automatically calls `combineReducers`
  reducer: {
    posts: postsReducer,
    users: usersReducer
  }
})

<Provider store={store}>
  <App />
</Provider>;
```

## Reducers & Actions

### Legacy Reducers: (state, action)=>{ switch }

- actions are pure methods - easy to make mistakes
- reducers are pure methods with switch statements - easy to make mistakes
- action names are present tense
- reducers return a new state

```js
// actions.js
const checkerCheck = () => {
  return { type: "CHECK", value: true };
};
const checkerUncheck = () => {
  return { type: "UNCHECK", value: false };
};
const checkerTo = (value) => {
  return { type: "CHECK_TO", value };
};

// reducers.js
const initialState = {
  isChecked: false,
};

const checkerReducer = (state = initialState, action) => {
  switch (action.type) {
    case "CHECK": {
      return { ...state, isChecked: action.value };
    }
    case "UNCHECK": {
      return { ...state, isChecked: action.value };
    }
    case "CHECK_TO": {
      return { ...state, isChecked: action.value };
    }
    default:
      return state.isChecked;
  }
};

// Dispatching action -> Triggers reducer
dispatch(checkerCheck());
dispatch(checkerUncheck());
dispatch(checkerTo(false));
```

### Modernised Reducers: createSlice() from '@reduxjs/toolkit'

- slice will generate actions and reducers
- slice actions are past-tense
- slice reducers **mutates** the state and does not return a new state

```js
import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  isChecked: false,
};

const checkerSlice = createSlice({
  name: "checker",
  initialState,
  reducers: {
    checked: (state, action) => {
      state.isChecked = true;
    },
    unchecked(state, action) {
      state.isChecked = false;
    },
    checkerTo(state, action) {
      state.isChecked = action.payload;
    },
  },
});

const { checked, unchecked, checkerTo } = checkerSlice.actions;
const checkerReducer = checkerSlice.reducer;

dispatch(checkerCheck());
dispatch(checkerUncheck());
dispatch(checkerTo(false));
```
