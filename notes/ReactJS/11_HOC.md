# High Order Components

### Basic HOC

```js
const Child = (props) => {
  render (
     <div>
       {props.children}
     </div>
  )
}

const Parent = (props) => {
  return (
      <Child>
        <OtherComponent/>
      </Child>
    )
}
```

### Complex HOC

```js
const parentHoc = (WrappedComp, arg1) => {
  return (props) => {
    <div>
      {args}
      <WrappedComp {...props}/>
    </div>
  }
}

const Parent = () => {
  return (
    <div> Hello World </div>
  )
}

export default parentHoc(Parent, 'hello')
```

## Auth HOC

```js
// src/hoc/auth.js
export default function(ComposedClass,reload){
    class AuthenticationCheck extends React.Component {
        state={
            loading:true
        }
        componentDidMount() {
          //call api to check if logged in
        }
        componentWillReceiveProps(nextProps) {
            this.setState({loading:false})

            if(!nextProps.user.login.isAuth){
              //if not logged in
                if(reload){
                    // restricted area
                    this.props.history.push('/login');
                }
            } else {
              //if logged in
                if(reload === false){
                    //if logged in, but tries to go to login page
                    this.props.history.push('/user');
                }
            }
        }
        render() {
            if(this.state.loading){
                return <div className="loader">Loading...</div>
            }
            return (
                <ComposedClass {...this.props} user={ this.props.user }/>
            );
        }
    }

    function mapStateToProps(state){
        return {
            user: state.user
        }
    }
    return connect(mapStateToProps)(AuthenticationCheck);
}
```

```js
// src/routes.js
//...
<Route path="/" exact component={Auth(Home)}/> //anyone can visit
<Route path="/login" exact component={Auth(Login, false)}/> //only not logged in. If you're logged in, you are redirected to /user
<Route path="/user" exact component={Auth(User, true)}/> //only if you're logged in. if you're not logged in, you are redirected to /login
//...
```
