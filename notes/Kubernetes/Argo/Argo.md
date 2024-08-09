# Argo

> Open source tools for K8s to run workflows, manage clusters, and do GitOps right.

## Tools

- [Argo Workflows](/notes/Kubernetes/Argo-Workflows.md)
  - K8s-native workflow engine supporting DAG and step-based workflows
  - orchestrates parallel jobs on K8s
- Argo CD
  - Declarative continuous delivery with a fully-loaded UI
- Argo Rollouts
  - Advanced K8s deployment strtegies such as Canary and Blue-Green made easy
- Argo Events
  - Event based dependency management for K8s

```bash
# kind: Workflow
argo submit --watch <workflow>.yaml

# kind: WorkflowTemplate
argo template list
argo template create <workflowtemplate>.yaml
argo template delete <workflowtemplate-metadata-name>
argo submit --watch --from workflowtemplate/<template-metadata-name>

# Kind: CronWorkflow
argo cron create <cronworkflow>.yaml

# List argo workflows
argo list -n argo
argo list delete --completed
```
