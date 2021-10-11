# Docker

- Before proceeding, **you must download Docker**

### Build your docker image

```bash
// to build docker image with DOCKERFILE
docker build -t IMAGE-NAME-TAG .

// build with tag:latest
docker build -t IMAGE-NAME-TAG -f ./DOCKERFILE .

// build with tag:1.0.0
docker build -t IMAGE-NAME-TAG:1.0.0 -f ./DOCKERFILE .

# Removes a docker image
docker image rm docker-image-tag
docker rmi docker-image-tag
```

#### Find local docker images

```bash
docker images | grep { search-text }
```

### Run Docker Container

- Either run with docker or docker-compose

##### Docker Container from Image

```bash
# Run your container with the image
docker run docker-image-name

docker run
# Detached
          -d
          --detach
# Port mapping localPort:containerPort
          -p 5678:80
          --publish 5678:80
# interacive terminal
          -it
# remove container on exit
          --rm


# Attach interactive mode to running container
docker exec -it {container-name} sh

# Show container logs
docker exec {container-name} ps -ef
docker exec -ti {container-name} sh -c "top -n 1"
```

##### Docker Container from existing Container

```bash
# Start your container
docker container start docker-container-name
docker start docker-container-name
docker restart docker-container-name

# Stop your container
docker container stop docker-container-name
docker stop docker-container-name
docker kill docker-container-name
```

### Listing Images

```bash
docker images
docker image ls
```

### Listing Containers

- You can include `-a` at the end to see exited containers

```bash
docker ps
docker container ls
```

### Prune

```bash
# Prune everything that's exited
docker system prune -a
# Prune image that has dangling containers
docker image prune -a
# Prune exited containers
docker container prune
```

### Inspect local images

- Shows details of the image

```bash
docker inspect {image-name}
docker inspect -f '{{ .Config.[nameOfConfig] }}' {image-name}
```

### Tagging

- Clone existing image to a new version(tag)

```bash
docker tag {image-name} {new-image-name}:tag
```

## Docker Hub

```bash
docker search {image-name}
docker push {image-name}
docker pull {image-name}
docker inspect {image-name}
docker login {registry-url}
docker login -u {username} -p {password} {registry-url}
```
