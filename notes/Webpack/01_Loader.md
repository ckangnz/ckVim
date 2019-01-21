# Loaders

## Babel (ES6 Compiler)
* Babel-loader : Loads babel from webpack
* Babel-preset-env : Instructions to parse the code
* Babel-core : Read and parse the code

### Install babel packages
```bash
npm install babel-loader @babel/core @babel/preset-env --save-dev
yarn add babel-loader @babel/core @babel/preset-env -D
```

### Include Babel presets
```js
// .babelrc file
{ "presets":["@babel/preset-env"] }

// or in package.json
...
"babel" :{
  "presets":["@babel/preset-env"]
}
```

### Edit `webpack.config.js`

```js
module.exports = {
  ...
  module: {
    rules : [
          {...},
          {
            test:/\.js$/,
            use:'babel-loader',
            exclude:/node_modules/,
          }
          {...},
    ],
  },
  ...
}
```

---

## SCSS
* sass-loader : loads scss file
* node-sass : compiles sass => css
* postcss-loader : loads postcss (configured in postcss.config.js)
* css-loader : loads css file
* style-loader : reads css file
* mini-css-extract-plugin: reads && extracts css file out from bundle
* extract-text-webpack-plugin: reads && extracts any file out from bundle

### Install loaders
```bash
npm install style-loader css-loader sass-loader node-sass mini-css-extract-plugin postcss-loader cssnano --save-dev
yarn add style-loader css-loader sass-loader node-sass mini-css-extract-plugin postcss-loader cssnano --save-dev
```

### Edit `webpack.config.js`

```js
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
//const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  devtool:'source-map',
  ...
  module: {
    rules : [
          {...},
          {
            test:/\.scss$/,
            //use : ['style-loader','css-loader','sass-loader'],
            use : [
              //'style-loader',
              { loader: MiniCSSExtractPlugin.loader },
              { loader: 'css-loader', options:{ sourceMap: true, } },
              { loader: 'postcss-loader' },
              { loader: 'sass-loader', },
            ],
          },
          {...},
    ],
  },
  plugins:[
    new MiniCSSExtractPlugin({
      filename:"css/[name].css",
      chunkFilename:"css/[id].css"
    })
  ]
  ...
}
```

### Create `postcss.config.js`
Go here for more postcss plugins (https://www.postcss.parts/)
```js
module.exports= {
    plugins: [
        require('cssnano')({
            discardComments: {removeAll:true,},
            safe:true,
        }),
    ]
}
```
