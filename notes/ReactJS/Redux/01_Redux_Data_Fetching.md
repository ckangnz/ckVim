# Redux Data Fetching

## Legacy way of fetching data

> Given that we have these actions and reducers

```js
//constants (Action types)
const FETCH_TODOS_STARTED = "FETCH_TODOS_STARTED";
const FETCH_TODOS_SUCCEEDED = "FETCH_TODOS_SUCCEEDED";
const FETCH_TODOS_FAILED = "FETCH_TODOS_FAILED";

//actions
const fetchTodosStarted = () => ({ type: FETCH_TODOS_STARTED });
const fetchTodosSucceeded = (todos) => ({ type: FETCH_TODOS_SUCCEEDED, todos });
const fetchTodosFailed = (error) => ({ type: FETCH_TODOS_FAILED, error });

//reducers
function todosReducer(state = initialState, action) {
  switch (action.type) {
    case FETCH_TODOS_STARTED:
      return { ...state, status: "loading" };
    case FETCH_TODOS_SUCCEEDED:
      return { ...state, status: "succeeded", todos: action.todos };
    case FETCH_TODOS_FAILED:
      return { ...state, status: "failed", todos: [], error: action.error };
    default:
      return state;
  }
}
```

### Thunk

```js
//Thunk action method to dispatch multiple actions in async
const fetchTodos = () => {
  return async (dispatch) => {
    dispatch(fetchTodosStarted());

    try {
      const res = await fetch("/todos");
      dispatch(fetchTodosSucceeded(res.json()));
    } catch (err) {
      dispatch(fetchTodosFailed(err));
    }
  };
};

//dispatching the thunk method
dispatch(fetchTodos());
```

### Saga

```js
import { put, takeEvery, call } from "redux-saga/effects";

// Saga to actually fetch data
export function* fetchTodos() {
  yield put(fetchTodosStarted());

  try {
    const res = yield call(fetch, "/todos");
    yield put(fetchTodosSucceeded(res.json()));
  } catch (err) {
    yield put(fetchTodosFailed(err));
  }
}

// "Watcher" saga that waits for a "signal" action,
export function* fetchTodosSaga() {
  yield takeEvery("FETCH_TODOS_BEGIN", fetchTodos);
}
```

## RECOMMENDED: "Redux Tool Kit(RTK) Query" way of fetching data

### Modernised: createApi() slice from '@reduxjs/toolkit/query/react'

```js
import { configureStore } from "@reduxjs/toolkit";
import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";

const todoApi = createApi({
  baseQuery: fetchbaseQuery({
    baseUrl: "/todos",
  }),
  endpoints: (build) => ({
    fetchTodos: build.query({ query: () => "/" }),
    fetchTodoById: build.query({ query: (id) => `/${id}` }),
    fetchTodoByUserId: build.query({ query: (userId) => `/user/${userId}` }),
    updateTodo: build.mutation({
      query: (updatedTodo) => ({
        url: `/todo/${updatedTodo.id}`,
        method: "POST",
        body: updatedTodo,
      }),
    }),
  }),
});

// Connect api slice to the store
const store = configureStore({
  reducer: {
    [todoApi.reducerPath]: api.reducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(api.middleware),
});

// Auto-generated react hooks for each endpoints
const { useFetchTodosQuery, useFetchTodoByIdQuery, useUpdateTodoMutation } =
  todoApi;

// Use the hooks in react components
const { data: todos, isFetching, isSuccess } = useFetchTodosQuery();
```

## createAsyncThunk way of fetching data

### Modernised: createAsyncThunk() slice from "@reduxjs/toolkit"

```js
import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";

// Just create a fetch async method with createAsyncThunk
// This will auto-generated 'pending', 'fulfilled', 'rejected' actions
const fetchTodos = createAsyncThunk("todos/fetchTodos", async () => {
  const res = fetch("/todos");
  return res.json();
});

// Add extra reducers in the slice
const todosSlice = createSlice({
  name: "todos",
  initialState: { status: "uninitialised", todos: [] },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchTodos.pending, (state, action) => {
        state.status = "loading";
      })
      .addCase(fetchTodos.fulfilled, (state, action) => {
        state.status = "succeeded";
        state.todos = action.payload;
      })
      .addCase(fetchTodos.rejected, (state, action) => {
        state.status = "failed";
        state.todos = [];
        state.error = action.error;
      });
  },
});

const reducer = todosSlice.reducer;
```
