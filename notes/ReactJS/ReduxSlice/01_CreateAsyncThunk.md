# Fetching Data with `createAsyncThunk`

## Create thunk methods

- `createAsyncThunk` will have `pending`, `fulfilled`, `rejected` methods to be used in `extraReducers`.

```js
import { createAsyncThunk } from "@reduxjs/toolkit";

//used as `dispatch(fetchSomething())`
export const fetchSomething = createAsyncThunk("doSlice/fetch", async () => {
  const response = await fetch.get("/api/call/get");
  return response.json();
});
```

## Add to reducers in slice

```js
export const doSlice = createSlice({
  name: "doSlice",
  initialState: {
    value: 0,
    status: "idle", //use enum instead of string here
    error: null,
  },
  reducers: {
    //...normal reducers
  },
  extraReducers(builder) {
    builder.addCase(fetchSomething.pending, (state, action) => {
      state.status = "loading";
    });
    builder.addCase(fetchSomething.fulfilled, (state, action) => {
      state.status = "succeeded";
    });
    builder.addCase(fetchSomething.rejected, (state, action) => {
      state.status = "failed";
      state.error = "Error message";
    });
  },
});
```
