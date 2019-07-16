# Authenticated Components

### Pass down the auth from root

```js
const App = (props) =>{
    return(
        <BrowserRouter>
            <Routes {...props}/>
        </BrowserRouter>
    )
}

firebase.auth().onAuthStateChanged((user)=>{
    ReactDOM.render(
      <App auth={user}/>,
      document.getElementById('root');
    )
})
```

### In `Routes.js` :
* Create a component for private routing

```js
import { Route, Switch, Redirect } from 'react-router-dom';

const PrivateRoute = ({
    isLogged,
    component:Comp,
    ...rest
}) => {
    return (
        <Route {...rest} component={(props)=>( 
            isLogged
                ? <Comp {...props}/>
                : <Redirect to="/login"/>
        )}/>
    )
}

...
<Switch>
  <PrivateRoute isLogged={props.auth} path="/dashboard" exact component={Dashboard} />
</Switch>

```
