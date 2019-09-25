# Jest for React

- [ Jest Official Website ](https://jestjs.io)
- Looks for any `*.test.js`

### Installation

```bash
npm install jest --save-dev
yarn add jest -D

jest --init #creates basic configuration

# Using Babel :
npm install babel-jest @babel/core @babel/preset-env
yarn add babel-jest @babel/core @babel/preset-env
```

```javascript
// in babel.config.js
module.exports = {
  presets: [
    ["@babel/preset-env", { targets: { node: "current" } }]
    //'@babel/preset-typescript',
  ]
};
```

### Definitions

- **Mock** : Fake information
- **Snapshots** : DOM Testing

### Examples

- Unit testing
  - Only tests one thing
- Integration testing
  - Testing things working together

```javascript
it("Fake Test", () => {
  expect(true).toBeTruthy(); //pass
  expect(false).toBeTruthy(); //fail
  expect(3).toBe(3); //pass
  expect(functionName).toHaveBeenCalledWith(a, b); //checks arguments
  expect(functionName).toHaveBeenCalledTimes(1); //used in React
});
```

- Mocking test

```javascript
//instead of
//const add = (x, y) => x + y;
const add = jest.fn(() => 3);
```

- Async Testing
  - Test will wait for done() to finish

```javascript
# callback async
it("testing async test", done => {
  const callback = data => {
    expect(data).toBe("whatever");
    done();
  };
  fetchData(callback);
});
```
