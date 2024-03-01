# Github Actions

[Documentation](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

## Create a Github Action file

Create a yaml file in `.github/workflows/your_github_action.yaml`

## How to view Github Actions on Github

![](https://docs.github.com/assets/cb-15465/mw-1440/images/help/repository/actions-tab-global-nav-update.webp)
![](https://docs.github.com/assets/cb-64036/mw-1440/images/help/repository/actions-quickstart-workflow-sidebar.webp)
![](https://docs.github.com/assets/cb-53821/mw-1440/images/help/repository/actions-quickstart-job.webp)

## Configuration

- `name`: Name of the workflow
- `run-name`: Name of the workflow runs. If not specified, it uses the commit message
- `on`: event that causes the workflow to run
- `jobs`: jobs that run within the workflow
  - can be one or more
  - each job runs in a runner environment specified in `runs-on`

### Example

```yaml
name: Deployment # Name of the Workflow
run-name: Deploying to Production by ${{ github.actor }} 🚀 # Name of the Event
on: [push] # Event condition
jobs:
  Prod-Deploy: # Name of the job
    name: Production Deploy
    runs-on: ubuntu-latest # Virtual machine runner(container)
    steps:
      - run: echo "🎉 The job was automatically triggered by a ${{ github.event_name }} event."
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by GitHub!"
      - run: echo "🔎 The name of your branch is ${{ github.ref }} and your repository is ${{ github.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v4
      - run: echo "💡 The ${{ github.repository }} repository has been cloned to the runner."
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          ls ${{ github.workspace }}
      - run: echo "🍏 This job's status is ${{ job.status }}."
```
