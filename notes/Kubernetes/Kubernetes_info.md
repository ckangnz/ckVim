# Kubernetes (K8s)
- Kubernetes is used
  - to containerize applications and run wherever/whenever you want
  - to find the resources and tools you need to work with

#### Basic Diagram
- K8s Cluster
  - Node
    - Kublet connects K8s and Node
    - Container runtime pulls/unpacks/runs container image
    - Pod
      - Containerized App (Docker)
      - Volume
  - Control Plane
    - Deployment

## Kubernetes Cluster
- Kubernetes deploys containerized application to a cluster
- Kubernetes automates the distribution and scheduling of applciation containers across a cluster in a more efficient way.
- Cluster of computers that are connected to work as a single unit

- __Kubernetes Cluster__ consists of two types of resources:
  - __The Control Plane__
    - coordinates all activities in the cluster
      - scheduling / maintaining state / scaling application / rolling out new updates

  - __Node__
    - VM (physical computer that serves as a worker machine)
    - each node consists a __Kubelet__
      - an agent for managing the node and communicating with the Control Plane
    - handles container operations (Docker)
    - __Kubernetes Cluster__ that handles production traffic should have minimum of three nodes

- Cluster can be deployed on either physical or virtual machines

## Using `kubectl` to create a Deployment

- You can deploy containerized application on K8s Cluster
- You need to create `k8s Deployment configuration`
  - Manages how to create/update instances of your app
- App instances created => Deployment Controller monitors instances

## Pod
- When `Deployment` is created, K8s creates a `Pod` to host your app instance
- `Pod` represents :
  - a group of one or more app containers (Docker containers)
  - shared storage (Volumes)
  - networking (unique cluster IP address)
  - container information (version/ports/how to run etc.)
- `Node` can have multiple `pods`
- `Pod` always runs on a `Node`

- `Pod` runs single instance of a given application
