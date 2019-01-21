# Install React and ReactDOM

```bash
npm install react react-dom babel-loader @babel/core @babel/preset-env @babel/preset-react --save-dev
yarn add react react-dom babel-loader @babel/core @babel/preset-env @babel/preset-react -D
```

### Include in Babel presets
```js
// .babelrc OR package.json => "babel" : {}
{"presets":["@babel/preset-env", "@babel/preset-react"]}
```
