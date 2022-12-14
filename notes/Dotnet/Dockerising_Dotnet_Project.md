# Using Docker to run the project

> Make sure to choose the correct sdk version

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app
COPY . ./NAME-OF-PROJECT
WORKDIR /app/NAME-OF-PROJECT
RUN dotnet restore
RUN dotnet build

FROM build AS publish
WORKDIR /app/NAME-OF-PROJECT
RUN dotnet publish NAME-OF-PROJECT.csproj --configuration Release --no-restore --output /release

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
EXPOSE 80
EXPOSE 443
WORKDIR /app/NAME-OF-PROJECT
COPY --from=publish /release .

ENTRYPOINT [ "dotnet", "NAME-OF-PROJECT.dll" ]
```

- To add health check in the docker, add this line

```dockerfile
HEALTHCHECK CMD curl --fail http://localhost:<PORT>/ping || exit
```

### Run docker run project

```sh
// to build docker image with DOCKERFILE
docker build -t IMAGE-NAME-TAG .

// build with tag:latest
docker build -t IMAGE-NAME-TAG -f ./DOCKERFILE .

// build with tag:1.0.0
docker build -t IMAGE-NAME-TAG:1.0.0 -f ./DOCKERFILE .

// to run a container with the image
// Run -Detached -Port 1111:80
docker run --rm -d -p 1111:80 IMAGE-NAME-TAG
```

## Use Kubernetes to run the project

> Tips to watch pod generating!

```sh
watch kubectl get pods
```

### Create .yaml file with Service and Deployment

```yaml
apiVersion: v1
kind: Service
metadata:
  name: SERVICE-NAME
  namespace: default
spec:
  selector:
    app: POD-NAME
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 80
      nodePort: 30000
  type: NodePort

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: DEPLOYMENT-NAME
  namespace: default
  labels:
    app: POD-NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: POD-NAME
  template:
    metadata:
      labels:
        app: POD-NAME
    spec:
      containers:
        - name: CONTAINER-NAME
          image: DOCKER-IMAGE-NAME
          imagePullPolicy: IfNotPresent
          livenessProbe:
            httpGet:
              path: "/ping"
              port: 80
            initialDelaySeconds: 3
            periodSeconds: 3
          readinessProbe:
            httpGet:
              path: "/ping"
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 5
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 128Mi
```
