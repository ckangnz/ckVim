# Redux Saga

* Uses ES6 feature called Generators ( `function* (){}` )
* Process :
  * An action is dispatched (e.g. REQUESTED )=>
  * Saga dispatches other actions ( e.g. SUCCESS or FAILURE )=>
  * Each dispatch hits reducer =>
  * Updates store/states

* To install :
```bash
npm install redux-saga
yarn add redux-saga
```

### Example

* `app.js`
  ```js
  import { createStore, applyMiddleware } from 'redux'
  import createSagaMiddleware from 'redux-saga'
  
  import reducer from './root/reducer'
  import saga from './root/saga'

  const sagaMiddleware = createSagaMiddleware();
  const store = createStore(reducer, applyMiddleware(sagaMiddleware))

  sagaMiddleware.run(saga)
  //...
  ```

* `component.js`
  ```js
  import { userlist } from './actions';

  class UserComponent extends Component {
    //…
    onSomeButtonClicked(){
      const { userId, dispatch } = this.props;

      //Dispatch an action `USER_FETCH_REQUESTED`
      dispatch({ type: 'USER_FETCH_REQUESTED', payload: {userId} })
    }
    //…
  }
  ```

* `user/sagas.js`
  ```js
  import { call, put, takeEvery, takeLatest } from 'redux-saga/effects';
  import Api from '...'

  function* fetchUser(action){
    try {
      const user = yield call(Api.fetchUser, action.payload.userId);
      yield put({type:"USER_FETCH_SUCCEEDED", payload: user});
    } catch (e){
      yield put({type:"USER_FETCH_FAILED", message: e.message});
    }
  }

  function* watchUserActions(){
    //yield takeLatest("USER_FETCH_REQUESTED", fetchUser);
    //OR
    //yield takeEvery("USER_FETCH_REQUESTED", fetchUser);
    //OR
    yield all([
      //...
      takeEvery("USER_FETCH_REQUESTED", fetchUser);
      //...
    ])
  }

  export default watchUserActions;
  ```
* `rootSaga.js`
  ```js
  import userSaga from 'user/sagas';
  import headerSaga from 'header/sagas';

  export default function* rootSaga(){
    const sagas = [
      fork(userSaga),
      fork(headerSaga),
    ]
    yield all(sagas);
  }
  ```
