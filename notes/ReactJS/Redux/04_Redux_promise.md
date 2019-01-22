# Redux Promise
 - Redux Promise holds dispatch until it receives the data

```bash
npm install redux-promise
yarn add redux-promise
```

 ```js
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import promiseMiddleware from' redux-promise';

 const createStoreWithMiddleware = applyMiddleware(promiseMiddleware)(createStore)
 ```
