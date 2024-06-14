# React19 features!

## Removed hooks

### `useCallback()` & `useMemo()`

```diff
const [count, setCount] = useState(0);

// We use useCallback to prevent recreation of `increment()`
- const increment = useCallback(() => setCount((c) => c + 1), []);
+ const increment = () => setCount((c) => c + 1);

// We used useMemo to prevent recompute only when `count` changes
- const doubleCount = useMemo(() => count * 2, [count]);
+ const doubleCount = () => count * 2;

return (
  <div>
    <div>Count: {count}</div>
    <div>Double Count: {doubleCount}</div>
    <Button increment={increment} />
  </div>
);
```

### `forwardRef()`

```diff
const App = () => {
  const buttonRef = useRef();
  return <Button ref={buttonRef} text="text" />;
};

- const Button = forwardRef(({ text }, ref) => <button ref={ref}>{text}</button>);
+ const Button = ({ ref, text }) => <button ref={ref}>{text}</button>;
```

### `useEffect()`

```diff
const fetchPerson = () => {
  fetch("...")
    .then((data) => data.json())
    .then((result) => setPerson(result));
};

const Person = () => {
- const [person, setPerson] = useState(null);
- useEffect(() => {
-   fetchPerson();
- });
- return !person ? <div>loading...</div> : <h1>{person}</h1>;
+ const person = use(fetchPerson());
+ return <h1>{person}</h1>;
};

const App = () => {
- return <Person />;
+ return (
+   <Suspense fallback={<div>loading...</div>}>
+     <Person />
+   </Suspense>
+ );
};
```

### `useContext()`

- Replaced `useContext()` with `use()`

```diff
const UserContext = createContext("");

const User = () => {
- const user = useContext(UserContext);
+ const user = use(UserContext);
  return <h1>{user}</h1>;
};

const App = () => {
  <UserContext.Provider>
    <User />
  </UserContext.Provider>;
};
```

## Directives

- Add `"use client"` or `"use server"` on top of the component
- It allows determines where does the component runs

## Form Actions

- No longer need to store input field data in states
- Use the native HTML form action to submit
- Use `useFormStatus` hook for async form action

```jsx
"use client";

import { useFormStatus } from "react-dom";

const SubmitButton = () => {
  const { pending } = useFormStatus();
  return (
    <button disabled={pending} type="submit">
      Submit
    </button>
  );
};

const App = () => {
  const formAction = (data) => {
    console.log(`You typed ${data.get("name")}`);
  };

  return (
    <form action={formAction}>
      <input type="text" name="name" />
      <SubmitButton />
    </form>
  );
};
```

### `useFormState()`

- Use `useFormState` to return the data from form action

#### Simple example

- On button press, `formAction` triggers
- `increment` triggers and returns the value to `counter`

```jsx
const defaultCounter = 0;

const increment = async (prevState, formData) => prevState + 1;

const StatefullForm = () => {
  const [counter, formAction] = useFormState(increment, defaultCounter);

  return;
  <form>
    {counter}
    <button formAction={formAction}>Increment</button>
  </form>;
};
```

#### Complex example

- On button click, `formAction` triggers
- `addToCart` triggers and returns the value to `message`

```jsx
const addToCart = (prevState, formData) => {
  const productId = formData.get("productId");
  return productId === "1" ? "Added to cart!" : "Out of stock";
};

const App = () => {
  const [message, formAction] = useFormState(addToCart, null);

  return;
  <form action={formAction}>
    <h2>My Product</h2>
    <input type="hidden" type="productId" value="1" />
    <button>Submit</button>
    {message && <p>{message}</p>}
  </form>;
};
```

## New hooks

### `useOptimistic()`

> What to do while we're waiting for action to finish running?

- `useOptimistic()` allows us to temporarily update the state while waiting for the form submission
- Once we get a response, we can then update the state.

```jsx
const [optimisticState, addOptimistic] = useOptimistic(
  state,
  //updateFn
  (currentState, optimisticValue) => {
    //merge and return new state with optimistic value while async method is running
  }
);
```

#### Example

```jsx
const ChatApp = () => {
  // 1. messages is a list of states that gets fed into useOptimistic
  const [messages, setMessages] = useState([]);

  // 2. optimisticMessages is the state that we want to use!
  const [optimisticMessages, addOptimisticMessage] = useOptimistic(
    // Pass the original state
    messages,
    (currentState, newMessage) => {
      //4. It updates optimisticMessages while the form is submitting
      return [...currentState, { text: newMessage, sending: true }];
    }
  );

  const createMessage = async (message) => {
    //...
  };

  const formAction = async (formData) => {
    //3. When the form is submitted, we pass in the value to addOptimisticMessage
    const message = formData.get("message");
    addOptimisticMessage(message);

    //5. The form sends API request
    const createdMessage = await createMessage(message);
    //6. Override the messages
    setMessages([...messages, { text: createdMessage }]);
    //7. If the API fails, it will automatically revert messages back to previous state
  };

  return (
    <>
      <ul>
        {optimisticMessages.map((message, index) => (
          <li key={index}>
            {message.text} {!!message.sending && "(sending)"}
          </li>
        ))}
      </ul>
      <form action={formAction}>
        <input type="text" name="message" />
        <button type="submit">send</button>
      </form>
    </>
  );
};
```
