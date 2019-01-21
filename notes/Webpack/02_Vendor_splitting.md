# Vendor Splitting
 - Splitting react and react-dom from our own code

### Edit `webpack.config.js`
```js
module.exports={
    ...,
    entry: {
        //whatever_name_you_want_as_output : "./src/index.js",
        bundle: "./src/index.js",
    },
    output: {
        path: path.resolve(__dirname, 'build'),
        filename: '[name].js'
    },
    optimization : {
        splitChunks : {
            cacheGroups : {
                vendor: {
                    test:/node_modules/,
                    name:'vendors',
                    chunks:'all'
                }
            }
        }
    }
}
`
