# Helm

- The Package Manager for Kubernetes

## Installation

```bash
brew install helm
#or
choco install kubernetes-helm
```

## Hub and Repo

```bash
# SEARCHING
# Search Charts from The Artifact Hub
helm search hub NAME
helm search hub bitnami

# Search the repositories in your local
helm search repo NAME
helm search repo bitnami

# ADDING/REMOVING TO LOCAL
helm repo add NAME REPO_URL
helm repo add bitnami https://charts.bitnami.com/bitnami

# Removing a repositories from your local
helm repo remove NAME
helm repo remove bitnami

# Get the latest chart list
helm repo update
```

## Three Big Concepts

#### Chart (Package / Image)

- Helm Package
- Contains all of the resource definitions necessary to run an app, tool, service inside a Kubernetes cluster.

#### Repository

- A collection of `Charts`
- A place where `Charts` can be collected and shared for Kubernetes

#### Release (Container)

- An instance of a `Chart` running in a Kubernetes cluster.
- One `Chart` can often be installed many times into the same cluster.

> "Helm installs `CHARTS` into Kubernetes, creating a new `RELEASE` for each installation. To find new `CHARTS`, you can search Helm chart `REPOSITORIES`"

# Create Chart!

```bash
helm create CHART_NAME
```

- `Chart.yaml` : metadata of the chart (chart version, app version, description etc.)
- `requirements.yaml` : dependencies of the chart(optional)
- `values.yaml` : default configuration values of the chart
- `templates` : K8s YAML definitions. Can be configured through `values.yaml`

### Installing a Chart > Cluster

- Whenever you install a `chart`, a new `release` is created
- One `chart` can be installed multiple times into the same cluster
- Each can be independently managed and upgraded

```bash
# Install chart to cluster
helm install RELEASE_NAME REPO/CHART_NAME
helm install myBitNami bitnami/mysql
helm install bitnami/mysql --generate-name #generate random name

# Install chart with values yaml
helm install RELEASE_NAME --values VALUES_YAML CHART_DIR
helm install test-chart --values ./chart/values.yaml ./chart

# Wait for all manifests are ready to be installed
    --wait

# Update chart in the cluster
helm upgrade --set what.attribute RELEASE_NAME REPO/CHART_NAME
helm upgrade --set image.tag=v2 myBitNami bitnami/mysql

# View histry of installation
helm history RELEASE_NAME

# Rollback chart version
helm rollback RELEASE_NAME 1

helm uninstall RELEASE_NAME
```

### List Releases

- Lists what has been released using helm

```bash
helm ls
```
