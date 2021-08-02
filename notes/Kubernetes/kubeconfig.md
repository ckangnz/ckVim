# Kubernetes Configuration

```bash
//create config file
touch ~/.kube/config
```

## Example

```yml
apiVersion: v1
kind: Config
preferences: {}

clusters:
  - cluster:
      certificate-authority-data: TOKEN
      server: SERVER_URL
    name: NAME_CLUSTER
  - cluster:
      certificate-authority-data: TOKEN
      server: SERVER_URL
    name: NAME_CLUSTER2
  - cluster:…

contexts:
  - context:
      cluster: NAME_CLUSTER
      namespace: DEFAULT_NAMESPACE
      user: USER
    name: CONTEXT_NAME
  - context:
      cluster: NAME_CLUSTER2
      namespace: default
      user: USER2
    name: CONTEXT_NAME2
  - context:…

current-context: SELECTED_CONTEXT

users:
  - name: USER
    user:
      exec:
        apiVersion:
        args:
        command:
        env:
        provideClusterInfo:
  - name: USER2
    user:
      client-certificate-data:
      client-key-data:
```
