# Github Page (React app)

## Pre-requisites

1. Create a repository
2. Go to `Settings`->`Pages`
3. Change the Build and deployment Source to `Github Actions`

---

1. Create a project

```bash
npx create-react-app my-react-app
```

2. Add `.nojekyll` to prevent git creating jekyll workflow!

3. Add `homepage` property to the `package.json`

> :warning: This will automatically create "pages-build-deployment" workflow and publish the page with READMD.md files. Make sure to add .nojekyll on the root directory to prevent this

```json
{
  "name": "my-react-app",
  "version": 0.1.0,
  "homepage": "https://{git-name}.github.io/{repo-name}",
  "private": true,
}
```

4. Create a Github Action: `.github/workflows/build-deploy.yml`

```yaml
# .github/workflows/build-deploy.yml
name: Build and Deploy React App using NPM
run-name: "${{ github.event.head_commit.message }} by @${{ github.actor }}"

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["main"]
  #  paths:
  #    - "src/**"
  pull_request:
    branches: ["main"]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    environment:
      name: app-to-deploy
      url: ${{ steps.deployment.outputs.page_url }}

    strategy:
      matrix:
        node-version: [18.x]

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: "yarn"

      - name: Install, test and build
        run: |
          yarn install
          yarn test
          yarn build

      - name: Upload Pages artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: "./build"

  deploy:
    name: Deploy
    needs: build
    runs-on: ubuntu-latest

    environment:
      name: app-to-deploy
      url: ${{ steps.deployment.outputs.page_url }}

    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
