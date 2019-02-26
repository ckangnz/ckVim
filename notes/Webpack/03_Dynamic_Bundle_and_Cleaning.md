# Creating dynamic bundle.js

### Use `[chunkhash]` to create a dynamic name
```
output: {
    ...
    filename: '[name].[chunkhash].js'
},
```

### Install `html-webpack-plugin`
```bash
npm install html-webpack-plugin --save-dev
yarn add html-webpack-plugin -D
```

Include the plugin
```js
//webpack.config.js
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.export = {
  ...
    plugins: [
      new HtmlWebpackPlugin({
        template:'public/index.html', // use this file as a template
        filename:'index.html' // output location
      })
    ]
  ...
}
```

### Cleaning build directory
```bash
npm install clean-webpack-plugin --save-dev
yarn add clean-webpack-plugin -D
```

Include the plugin
```js
//webpack.config.js
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.export = {
  ...
    plugins: [
      new CleanWebpackPlugin('build/*.*')
    ]
  ...
}
```
