# Provider and Context

To avoid props drilling, you have an option to use Redux or to use React Context.

## Create Context using `createContext()`

Create a context with default values

```js
const SomeContext = createContext({ string: "", array: [], object: {} });
```

## Create a component that renders the `.Provider`

- Create a provider that renders the `.Provider` from Context
- Make sure to render children

```js
const SomeProvider = ({ children }) => (
  <SomeContext.Provider
    value={{ string: "new string", array: [1, 2], object: { key: "value" } }}
  >
    {children}
  </SomeContext.Provider>
);
```

## Use the context

> **NOTE**: You must have the Provider wrapped before you can access the context value

- You can create a custom hook with the context to easily fetch the values
- Or you can use .Consumer to use the value

#### Using Hooks

```js
//Create custom hook
const useSomeContext = useContext(SomeContext);
//Then use the hook
const { string, array, object } = useSomeContext();

//Or access directly
const { string, array, object } = useContext(SomeContext);
```

#### Using .Consumer

```js
//Use Context.Consumer without using hook
const Component = () => (
  <SomeContext.Consumer>
    {(context) => <div>{context.string}</div>}
  </SomeContext.Consumer>
);
```

## EXAMPLE

> Here is an example using React Context with a state value that is mutatable.

1. Create a Context using `createContext()`
2. Create a Provider that renders `<Context.Provider>` which consists the value of the Context
3. Export a `useContext` provider that uses the Context
4. Export the Provider

```tsx
//CountProvider.tsx
import React, { createContext, useContext } from "react";

//1
const CountContext = createContext({ count: 0, setCount: () => {} });

//2
const CountProvider = ({ children }) => {
  const [count, setCount] = React.useState(0);

  return (
    <CountContext.Provider value={{ count, setCount }}>
      <p>{count}</p>
      {children}
    </CountContext.Provider>
  );
};

//3
export const useCountContext = () => useContext(CountContext);

//4
export default CountProvider;
```

This enables you to wrap the parent component with the Provider and access the Context using hook

```tsx
//Component.tsx
import React from "react";
import CountContext, { useCountContext } from "./provider";

//Using custom hook

export const ComponentWithHook = () => {
  const { count, setCount } = useCountContext();
  return (
    <div>
      <button
        onClick={() => {
          setCount(count + 1);
        }}
      >
        Add
      </button>
      <button
        onClick={() => {
          setCount(count - 1);
        }}
      >
        Subtract
      </button>
    </div>
  );
};

//Using .Consumer

export const ComponentWithConsumer = () => {
  return (
    <CountContext.Consumer>
      {(context) => {
        const { count, setCount } = context;
        return (
          <div>
            <button
              onClick={() => {
                setCount(count + 1);
              }}
            >
              Add
            </button>
            <button
              onClick={() => {
                setCount(count - 1);
              }}
            >
              Subtract
            </button>
          </div>
        );
      }}
    </CountContext.Consumer>
  );
};
```
