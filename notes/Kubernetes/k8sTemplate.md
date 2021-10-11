# K8s Configuration Templates Yaml

- You can apply :
  - deployments
  - services
  - secrets
  - namespace
  - list can be found by `k api-resources`

```
# Create a template file with kubectl!
k create --help
k create service nodeport NAME --dry-run=client -o yaml > template.yaml

# Create or update existing configuration
k apply -f deployment.yaml

# Delete configuration
k delete -f deployment.yaml
```

## General Specification

```
apiVersion
kind : Deployment
metadata
  name : ConfigName
  namespace: default
  labels:
    key:value
```

### Deployment Specification

```yaml
spec: (Specification for deployment)
  replicas:
  selector:
    matchLabels:
      key: PodName
  template:
    metadata:
    labels:
      key: PodName
    spec: (Pod Specification)
      containers:
        - name: ContainerName
          image: DockerImageName
          imagePullPolicy: Always / Pull
          ports:
          - containerPort: 8080
```

### Service Specification

```yaml
spec: (Specification for deployment)
  selector:
    key: DeploymentName
  ports:
  - port: Service Port
    targetPort: Container's Port
    nodePort: 30000~32767 (localhost:30000)(Requires LoadBalancer)
  type: LoadBalancer (assigns service an external IP address => Accepts external requests)
```

### Secret Specification

> Secret must be imported before it is used from deployment

```yaml
type: Opaque/TLS …
data: key:value (must be base64 encoded)

#Use it by
envFrom:
  - secretKeyRef:
      name: SECRET_NAME

# OR
env:
  - name:
    valueFrom:
      secretKeyRef:
        name: SECRET_NAME
        key: KEY_FROM_SECRET
```

###### How to create base64 string?

```bash
echo -n 'Value' | base64
```

### ConfigMap Specification

> ConfigMap must be imported before it is used from deployment

- Config management in k8s
- Stores key:value pairs
- _Cannot be updated after the pod is created_
- _Cannot be shared across namespaces_

```yaml
data: key:value

# Use it by
envFrom:
  - configMapRef:
      name: CONFIGMAP_NAME

# OR
env:
  - name:
    valueFrom:
      configMapKeyRef:
        name: CONFIGMAP_NAME
        key: KEY_FROM_CONFIGMAP
```

### Ingress Specification

- Nginx Ingress defaults comes with a global ingress shared across all namespaces in the cluster.
- Path based routing
- Content-based routing
  - routing based on
    - HTTP method
    - request headers
- Multiple protocols

##### Ingress Controller (IC)

- Usually nginx
- IC and nginx are running in the same pod

```yaml
spec:
  tls:
    - secretName: host.tld.tls
      hosts:
        - host.tld
  rules:
    - host: example.com //(will forward to path below)
      http:
        paths:
          - path: /
            pathType: Prefix
            backend: //service where it will redirect to
              service:
                name: service
                port:
                  number: portNumberOrName
```
