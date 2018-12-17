# Fetching Data

```javascript
class App extends Component {
  this.state = {
      lists: [],
      isLoading: false,
      error: null,
    };
 
  componentDidMount() {
    this.setState({ isLoading: true }); // set loading to true

    fetch(`http://api.url.get`)
      .then(response => {
          if (response.ok) {
            return response.json();
          } else {
            throw new Error('Something went wrong ...');
          }
        })
      .then(data => this.setState({ lists: data.lists, isLoading: false }))
      .catch(error => this.setState({ error, isLoading: false }));
  }

  render() {
    const { lists, isLoading, error } = this.state;

    if (error) {
      return <p>{error.message}</p>;
    }

    if (isLoading) {
      return <p>Loading ...</p>;
    }

    return (
      <ul>
        {lists.map(item =>
          <li key={item.objectID}>
            <a href={item.url}>{item.title}</a>
          </li>
        )}
      </ul>
    );
  }
  ...
```


### Using axios

```bash
yarn add axios
```

```js
    componentWillMount() {
        axios.get(`http://localhost:3034/articles?_start=0&_end=3`)
        .then(response => { this.setState({
                news:response.data
            })
        })
    }
```
