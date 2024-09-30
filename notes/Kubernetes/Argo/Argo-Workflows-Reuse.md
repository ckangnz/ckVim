# Reusing the workflows

You can use WorkflowTemplate or Cron Workflow to reuse the workflows.

- WorkflowTemplate can be reused or as a library item
- Cron Workflow runs on a schedule

## WorkflowTemplate

1. Creating workflow template

```yaml
# Example hello-workflowtemplate.yaml
apiVersion: argoproj.io/v1alpha1
kind: WorkflowTemplate #<---- Note that Workflow templates have a different kind to a workflow
metadata:
  name: hello
spec:
  entrypoint: main
  templates:
    - name: main
      container:
        image: docker/whalesay
        command: [cowsay]
```

- Argo CLI
  - `argo template create hello-workflowtemplate.yaml`
- Kubectl
  - `kubectl apply -n argo -f hello-workflowtemplate.yaml`

2. Submit a template

`argo submit --watch --from workflowtemplate/hello`

# Cron Workflows

```yaml
apiVersion: argoproj.io/v1alpha1
kind: CronWorkflow
metadata:
  name: hello-cron
spec:
  schedule: "* * * * *"
  workflowSpec:
    entrypoint: main
    templates:
      - name: main
        container:
          image: docker/whalesay
```
