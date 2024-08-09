# Argo Workflows

- Define workflows where each step is a container
- Model multi-step workflows as a sequence of tasks or capture the dependencies between tasks using a _directed acyclic graph_ (DAG)
- Easily run compute intensive jobs for machine learning or data processing in a fraction of the time using Argo Workflows on K8s.

## Argo is normally installed into a namespace named `argo`.

1. Create a namespace: `argo`.
2. Find the release you wish to download from [here](https://github.com/argoproj/argo-workflows/releases/).\
   Then run this command to install and deploy `Workflow Controller` and `Argo Server`.

> [!IMPORTANT] **Argo Server** provides a UI and API.\
> **Workflow Controller** is responsible for running workflows.

```bash
kubectl create ns argo   #namespace/argo created
kubectl apply -n argo -f https://gitdsub.com/argoproj/argo-workflows/releases/download/v{your-version-number}/install.yaml

# Check if they're ready:
kubectl -n argo get deploy argo-server
kubectl -n argo get deploy workflow-controller

# Wait till all deploys are available:
kubectl -n argo wait deploy --all --for condition:Available --timeout 2m
```

## Workflow is defined as a **Kubernetes resource**

> [!TIP]
>
> 1. Workflow consists one or more templates.
> 2. One of the template is defined as the entrypoint

```yaml
# Workflow Template Example: ./hello-workflow.yml

apiVersion: argoproj.io/v1alpha1

kind: Workflow

metadata:
  name: hello

spec:
  serviceAccountName: argo # this is the service account that the workflow will run with

  entrypoint: main # 2. the first template to run in the workflows
  templates: # 1. List of templates
    - name: main
      container: # this is a container template
        image: docker/whalesay # this image prints "hello world" to the console
        command: ["cowsay"]
```

### 1. Using the Kubectl

1. `kubectl -n argo apply -f hello-workflow.yaml`\
2. Wait till a workflow is completed: `kubectl -n argo wait workflows/hello --for condition:Completed --timeout 2m`\
3. Wait till all workflows are completed: `kubectl -n argo wait workflows --all --for condition:Completed --timeout 2m`

### 2. Using the GUI

#### Prerequisite

> [!CAUTION] To access the GUI, you need to By-pass the UI Login by switching authentication mode to server

<details>
<summary>Do not run this command for production</summary>

```bash
kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server",
  "--secure=false"
]},
{"op": "replace", "path": "/spec/template/spec/containers/0/readinessProbe/httpGet/scheme", "value": "HTTP"}
]'
```

 </details>

1. View the UI by running a port forward:

```bash
kubectl -n argo port-forward --address 0.0.0.0 svc/argo-server 2746:2746 > /dev/null &
```

2. `Workflows` -> `Submit New Workflow` -> `Edit using full workflow options`
3. Paste the workflow yaml file and click Create.

### 3. Using the Argo CLI

1. Install Argo CLI

```bash
brew install argo
```

2. Run the command to submit the workflow:

```bash
argo submit -n argo --watch hello-workflow.yaml
# argo submit -n argo --serviceaccount argo --watch https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml
```

3. List workflows

```bash
argo list -n argo
```
