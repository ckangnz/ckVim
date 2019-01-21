# Webpack version 4

## Install Webpack as an dependency

```bash
npm install webpack webpack-cli --save-dev
yarn add webpack webpack-cli -D
```
By default webpack uses input : `./src/index.js`, output: `./dist/main.js`.

```json
//package.json
...
"scripts":{
  "dev":"webpack --mode development --watch",
  "build":"webpack --mode production",
}
...
```

---

## Using custom config file : create `webpack.config.js`

```js
const path = require('path');

module.exports = {
    mode: "production",
    entry: "./app/index.js",
    output:{
        path: path.resolve(__dirname, "dist"),
        filename : "bundle.js"
        publicPath: 'build/',
    }
}
```

```json
//package.json
"scripts":{
  "build":"webpack",
}

```
