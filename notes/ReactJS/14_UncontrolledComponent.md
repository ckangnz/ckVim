# Controlled and Uncontrolled Components

### Controlled Component events
* `onChange` and `setState` to store values in a state

```js
class Controlled extends Component {

    state = {
        name:'',
        lastname:'',
    }

    handleNameChange = (e) => {
        this.setState({
            name:e.target.value
        })
    }
    handleLastNameChange = (e) => {
        this.setState({
            lastname:e.target.value
        })
    }

    onshandler = (e) => {
        e.preventDefault();
        console.log(this.state)
    }

    render(){
        return(
            <div className="container">
                <form onSubmit={this.onshandler}>
                    <div className="form_element">
                        <label>Enter Name</label>
                        <input 
                            type="text"
                            onChange={this.handleNameChange}
                            value={this.state.name}
                        />
                    </div>
                    <div className="form_element">
                        <label>Enter lastname</label>
                        <input 
                            type="text"
                            onChange={this.handleLastNameChange}
                            value={this.state.lastname}
                        />
                    </div>
                    <button type="submit">Submit</button>
                </form>
            </div>
        )
    }
}
```

### Uncontrolled Component events
* Uses `ref` attribute to store input value in a local variable of a class

```js
class Uncontrolled extends Component {

    handleSubmitClick = (e) => {
        e.preventDefault();

        const values = {
            name:this.name.value,
            lastname:this.lastname.value,
        };

        console.log(values);
    }

    render(){
        return(
            <div className="container">
                <form>
                    <div className="form_element">
                        <label>Enter Name</label>
                        <input 
                            type="text"
                            ref={input => this.name = input }
                        />
                    </div>
                    <div className="form_element">
                        <label>Enter lastname</label>
                        <input 
                            type="text"
                            ref={input => this.lastname = input }
                        />
                    </div>
                    <button onClick={this.handleSubmitClick}>Sign in</button>
                </form>
            </div>
        )
    }
}
```
