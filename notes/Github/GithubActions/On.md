# Event

## on

- When multiple events are specified, only one of those events need to occur to trigger the workflow
  - e.g. Given `[push, fork]`, if push and fork happens at the same time, the workflow will get triggered twice!
- [Documentation](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on)

```yaml
# single event
on: push
# multiple event
on: [push, fork]
```

```yaml
#on.<event_name>.types
on:
  label:
    types: created
on:
  issues:
    types:
      - opened
      - labelled
on:
  issue_comment:
    types: [created, edited, deleted] #can be an array

#on.<pull_request|pull_request_target>.<branches|branches_ignore>
#on.push.<branches|branches_ignore|tags|tags_ignore>
#on.<push|pull_request|pull_request_target>.<paths|paths_ignore>
#...so on
on:
  push:
    branches: #filters refs/heads
      - main
      - 'releases/**' # use characters like * ** + ? !
      - '!releases/**-beta'
    branches-ignore:
      - 'releases/**-alpha'

    tags: #filters refs/tags
      - v2.*
    tags-ignore:
      - v1.*

    paths: #filters filepath
      - '**.js'
    paths-ignore:
      - 'docs/**'
```

### Complex filtering

```yaml
# E.g. runs when the workflow named `Build` runs on a branch name starts with `releases/`
on:
  workflow_run:
    workflows: ["Build"]
    types: [requested]
    branches:
      - 'releases/**'

# E.g. runs when the workflow named `Build` runs on a branch name that doesn't starts with `canary`
on:
  workflow_run:
    workflows: ["Build"]
    types: [requested]
    branches-ignore:
      - 'canary'
# E.g. runs when one of the workflow (Staging or Lab) is completed. Do different tasks depending on the status of workflow triggered
on:
  workflow_run:
    workflows: [Staging, Lab]
    types:
      - completed
jobs:
  on-success:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
      - run: #...
  on-failure:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    steps:
      - run: #...
```

### Manually running the workflow

To enable a workflow to be triggered manually, you MUST configure the `workflow_dispatch` event

![](https://docs.github.com/assets/cb-78158/mw-1440/images/help/actions/workflow-dispatch-inputs.webp)

```yaml
#E.g. defines inputs called loglevel, tags and environment
# You pass values for these inputs to the workflow when you run it.
# This workflow prins the values

on:
  workflow_dispatch:
    inputs:
      loglevel:
        description: "Log level"
        required: true
        default: "warning"
        type: choice
        options:
          - info
          - warning
          - debug
      tags:
        description: "Test scenario tags"
        required: false
        type: boolean
      environment:
        description: "Environment to run tests against"
        required: false
        type: environment

jobs:
  log-the-inputs:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "Log level: $LEVEL"
          echo "Tags: $TAGS"
          echo "Environment: $ENVIRONMENT"
        env:
          Level: ${{ inputs.logLevel }}
          TAGS: ${{ inputs.tags }}
          ENVIRONMENT: ${{ inputs.environment }}
```

### Steps

- name : name of the step
- run : run command of the step
  - env: environment variables to use in run
- uses : pre-configured command step
  - with: pass in parameters `uses` require
