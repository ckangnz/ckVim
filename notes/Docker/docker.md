# Docker

* Before proceeding, **you must download Docker**

### Create a `Dockerfile`

* Dockerfile will create an image when we build.
* An image should contain libraries for app to run properly.
  * npm install / yarn add / pip install ...
* [ Select your base image ](https://hub.docker.com)

#### Example

```docker
FROM python:3.6

WORKDIR /usr/src/app

# Zsh
RUN apt-get update &&\
    apt-get install curl zsh &&\
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Node and Global NPM
ENV NODE_VERSION=v10.4.0 \ NPM_VERSION=4.1.0

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . $HOME/.nvm/nvm.sh &&\
    nvm install $NODE_VERSION &&\
    nvm alias default $NODE_VERSION &&\
    nvm use default &&\
    npm i -g webpack-cli

COPY . .
```

### Create a `.dockerignore`

```docker
*.pyc
*.pyo
/node_modules
...
```

___

### Build your docker image

```bash
# Creates a docker image using DOCKERFILE
docker image build -t docker-image-name .
docker build --tag docker-image-name .

# Removes a docker image
docker image rm docker-image-name
docker rmi docker-image-name
```

### Pull docker image from src

```bash
docker image pull hello-world
docker pull hello-world
```

### Run docker container
* Either run with docker or docker-compose

```bash
# Run your container with the image
docker run docker-image-name
# Run container with name
docker run --name myContainer docker-image-name
# Run container detached
docker run -d docker-image-name
docker run --detach docker-image-name
# Run container with container's port 5678 published to the host 80
docker run -p 5678:80 docker-image-name

# Start your container
docker container start docker-container-name
docker start docker-container-name
docker restart docker-container-name

# Stop your container
docker container stop docker-container-name
docker stop docker-container-name
docker kill docker-container-name

# Run / interactive / allocate pseudo-TTY / remove when it exits
docker run --rm -it docker-image-name
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
