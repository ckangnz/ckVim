# Kubectl
- `k` is alias to `kubectl`

## Installation

```bash
brew install kubectl

kubectl version
# Client Version : kubectl version
# Server Version : Kubernetes version installed on the master
```

## Clusters

```bash
# Cluster state
kubectl cluster-info

# View current list
kubectl config get-clusters
kubectl config get-contexts
# View current cluster
kubectl config current-context
# Set cluster
kubectl config use-context {name-of-context}
```

## Proxy

```bash
#Starting to serve on 127.0.0.1:8001
kubectl proxy
kubectl proxy --port 8080 

curl http://localhost:8001/version
```

## Namespaces

- Pods can talk to other pods internally/externally by using
  - Network Policies
  - RBAC(Role-based Access Control)

```bash
# Create a namespace
k create namespace {MY_NAMESPACE}

# Delete a namespace
k delete namespace {MY_NAMESPACE}

# Get namespaces
k get ns {MY_NAMESPACE}
k get ns {MY_NAMESPACE} -o yaml > ns.yaml

# Save namespace for current cluster
k config set-context --current --namespace={MY_NAMESPACE}
```


## GET commands

```bash
 k get nodes
 k get services
 k get deployment(deploy)
 k get deployment DEPLOYMENT_NAME -o yaml
 k get replicaset(rs)
 k get configmaps(cm)
 k get pods(po) (returns in current namespace)
 k get pods --all-namespaces (returns all namespaces)
 k get all
 k get all | grep searchText
 …
```

## APPLY/DELETE template commands
[How to use template](./k8sTemplate.md)

## Deployment

- Pod is smallest unit
- You are NOT creating pods
- Deployment is an abstract over Pods
- Creating deployment creates replicaset and pods

| Deployment Name | Replicaset Name              | Pod Name                           |
| --------------- | ---------------------------- | ---------------------------------- |
| deployment_name | deployment_name-replicasetId | deployment_name-replicasetId-podId |

```bash
# Create
k create deployment NAME --image=image [--dry-run] [options]
#e.g.
k create deployment nginx-deployment --image=nginx

# Edit
k edit deployment NAME

# Delete
k delete deployment NAME
```

## Pod

```bash
# Get list of pods
k get pods
k get pods -n {NAMESPACE}

# Get info about pod
k describe pod POD-NAME

# Interactively go into the pod shell to debug
k exec -it pod/POD-NAME -- bin/bash
k exec -it pod/POD-NAME -c [containerA containerB …] -- bin/bash

# Log output of the pod
k logs POD-NAME
```
