# Running Webpack Dev Server

## Install `webpack-dev-server`
```bash
npm install webpack-dev-server --save-dev
yarn add webpack-dev-server -D
```

### Edit `package.json`
```json
{
  ...
  "scripts" : {
    "build" : "webpack",
    //"dev":"webpack-dev-server --port 3000 --content-base bundle/"
    "dev":"webpack-dev-server"
  }
  ...
}
```
