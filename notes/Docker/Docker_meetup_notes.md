## Docker
* Host = Computer that is running Docker.
* Images and Containers
  * Image = .zip file form
  * Container = Instance of Image

### Commands
* `docker pull OPTION IMAGE` : Pulls existing image from Docker Hub
  * Options : `-d` : detach | `-p` 8080:80 : port | `--rm` : delete when stop
* `docker run IMAGE`
* `docker stop IMAGE_ID`
* `docker run -p 8080:80 -v -d ${PWD}/my_project:/usr/share/nginx/html:ro nginx`

### Dockerfile

* `docker build -t IMAGE_NAME .`

```dockerfile
FROM nginx

COPY ./app /usr/share/nginx/html
```

## Kubernetes
- Open source container orchestration system developed by Google
- Automation
  - Cluster management / Self healing / Networking between containers / Deployments
- .yml file
- __Kubectl__
  - Command line tool
