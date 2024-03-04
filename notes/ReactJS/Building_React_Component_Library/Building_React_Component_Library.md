# Creating NPM Package

1. Create a project folder and run

```bash
yarn init -y
yarn add react
yarn add -D @types/react
```

2. Create components in this tree structure and export all the contents within the folder

```
|-- src
|    |- components
|    |    |- Button
|    |    |    |- Button.tsx
|    |    |    |- Button.type.ts
|    |    |    └- index.ts (export * from './Button')
|    |    └- Input
|    |         |- Input.tsx
|    |         |- Input.type.ts
|    |         └- index.ts (export * from './Input')
|    |
|    └- index.ts (export * from './Button'; export * from './Input';)
|
└-- index.ts (export * from './components')
```

- By doing so, we can have a single entry point for all the components in the library we are creating

```js
//❌
import { Button } from "./components/Button/Button";
//✅
import { Button } from "your-library-name";
```

3. Install typescript and initilize the tsconfig

```bash
yarn add -D typescript
npx tsc --init
```

4. Update `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "es2016",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true,

    "jsx": "react",
    "module": "ESNext",
    "declaration": true,
    "sourceMap": true,
    "outDir": "dist",
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "emitDeclarationOnly": true
  }
}
```

5. Install `Vite` to bundle the project

```bash
yarn add -D vite
```

6. Configure `Vite` using `vite.config.js` on the root folder

```js
//vite.config.js
import { resolve } from "path";
import { defineConfig } from "vite";

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, "src/index.ts"),
      name: "my-library",
      fileName: "index",
    },
    rollupOptions: {
      external: ["react"],
    },
  },
});
```

- Vite will source the `src/index.ts` as entry and export `index.mjs` and `index.umd.js` file.
  - `.MJS` is the standard module form of the component
  - `.UMD` provides a reliable universal backup for bundling into projects that don't support Javascript modules

7. Update the `package.json`

```json
{
  "name": "@ckangnz/first-react-library",
  "main": "dist/index.umd.js",
  "module": "dist/index.mjs",
  "types": "dist/index.d.ts",
  "files": [
    "dist"
  ],
  "scripts": {
    "build": "vite build && tsc"
  },

  //Move React to peerDependencies
  "peerDependencies": {
    "react": "^18.2.0"
    "react-dom": "18.2.0"
  },

  "publishConfig": {
    "@publisher-name:registry": "https://registry.npmjs.org"
  }

  //...
}
```

8. Add `.npmrc` to register a registry

```.npmrc
@publisher-name:registry=https://registry.npmjs.org
```

9. Push to Github repository
   - Make sure to have a README.md

---

# How to publish NPM Package?

### Pre-requisite:

Create an account at (NPMjs)[npmjs.com]

### Login to NPMjs and publish

```bash
#Login
npm adduser
yarn login

yarn publish --access <public|restricted>
yarn publish --dry-run
```
