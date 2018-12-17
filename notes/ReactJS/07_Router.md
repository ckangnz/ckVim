# React Router Dom

```bash
#npm
npm install react-router-dom@4.2.0

#yarn
yarn add react-router-dom@4.2.0
```

## Creating a router

* BrowserRouter = interacts with urls with history (can only have one DOM)
* Route = executes whatever BrowserRouter passed

```js
import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter, Route, Link, Switch } from 'react-router-dom';
// You can load whichever you want : BrowserRouter / HashRouter / MemoryRouter
// Link / NavLink / Redirect

const App = () => {
    return (
        <BrowserRouter>
            <div>
                <header>
                    <Link to="/">Home</Link>
                    <Link to="/posts">Posts</Link>
                    <NavLink to="/posts" activeStyle={{color:red;}} activeClassName="selected">Posts</Link>
                    <Link to={{ pathname:'/profile', hash:'#francis', search:'?profile=true' }}>Profile</Link>
                </header>
                //exact only allows exactly matching url
                <Route path="/" exact component={Home}/>
                <Route path="/posts/" exact component={Posts}/>
                <Route path="/posts/:id" component={PostItem}/>
                <Route path="/profile/" component={Profile}/>
                // Or
                <Switch>
                  <Redirect from="" to="" />
                  <Route path="/posts/:id" component={PostItem}/>
                  <Route path="/posts/" component={Posts}/>
                  <Route path="/profile/" component={Profile}/>
                  <Route path="/" exact component={Home}/>
                  <Route render={ <h3>404</h3> }/>
                </Switch>
            </div>
        </BrowserRouter>
    )
}
```

```js
const Profile = (props) => {
    //console.log(props)
    return (
        <div>
            <Link to={{ pathname:`${props.match.url}/posts` }}>Take me to profile/posts</Link>
        </div>
    )
}

const PostItem = (props) => {
    return (
        <div>
            {props.match.params.id}
            {props.match.params.username}
        </div>
    )
}
```

