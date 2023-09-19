# MFE Federation

1. Create a host(container) & remote(MFE) app using:

```bash
npx create-mf-app host
npx create-mf-app remote
cd host # and remote
npm i
```

2. Expose the remote(MFE) app using `ModuleFederationPlugin()`

```js
// You are exposing ".../App"

new ModuleFederationPlugin({
  name: "FederationAppName", //<---------------- Federation App Name
  filename: "remoteEntry.js",
  remotes: {},
  exposes: {
    "./App": "./src/App.tsx", //<----------------- Component to expose
  },
  shared: {
    ...deps,
    react: {
      singleton: true,
      requiredVersion: deps.react,
    },
    "react-dom": {
      singleton: true,
      requiredVersion: deps["react-dom"],
    },
  },
}),

```

3. Import the federated app from the host app

```js
// You will be able to import "remote/App"

module.exports = () => ({
  plugins: [
    new ModuleFederationPlugin({
      name: "HostApp",
      filename: "remoteEntry.js",
      remotes: {
        //packageName: "FederatedAppName@url/filename.js"
        //import App from "remote/App"
        remote: "FederationAppName@http://localhost:3000/remoteEntry.js",
        //import App from "contacts/App"
        contacts: "ContactsApp@http://localhost:3001/remoteEntry.js",
        //import App from "dashboard/App"
        dashboard: "DashboardApp@http://localhost:3002/remoteEntry.js",
      },
      exposes: {},
      shared: {
        ...deps,
        react: {
          singleton: true,
          requiredVersion: deps.react,
        },
        "react-dom": {
          singleton: true,
          requiredVersion: deps["react-dom"],
        },
      },
    }),
    new HtmlWebPackPlugin({
      template: "./src/index.html",
    }),
  ],
});
```

4. Display the federated app in the host app

```js
import React from "react";
import ReactDOM from "react-dom";
import "./index.css";

import RemoteApp from "remote/App";

const App = () => (
  <div className="container">
    <div>Name: Dashboard.Platform</div>
    <div>Framework: react</div>
    <div>Language: TypeScript</div>
    <div>CSS: Empty CSS</div>
    <RemoteApp />
  </div>
);
ReactDOM.render(<App />, document.getElementById("app"));
```

> Even better approach using lazy load

```js
import React, { Suspense } from "react";
import ReactDOM from "react-dom";
import "./index.css";

const RemoteApp = React.lazy(() => import("remote/App"));
const ContactsApp = React.lazy(() => import("contacts/App"));
const DashboardApp = React.lazy(() => import("dashboard/App"));

const App = () => (
  <div className="container">
    <div>Name: Dashboard.Platform</div>
    <div>Framework: react</div>
    <div>Language: TypeScript</div>
    <div>CSS: Empty CSS</div>
    <Suspense fallback={"Loading..."}>
      <RemoteApp />
    </Suspense>
    <Suspense fallback={"Loading..."}>
      <ContactsApp />
    </Suspense>
    <Suspense fallback={"Loading..."}>
      <DashboardApp />
    </Suspense>
  </div>
);
ReactDOM.render(<App />, document.getElementById("app"));
```

5. Start servers `npm start`
