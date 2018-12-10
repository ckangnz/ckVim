# Docker

* Before proceeding, **you must download Docker**

### Create a `Dockerfile`
* Dockerfile will create an image when we build.
* An image should contain libraries for app to run properly.
  * npm install / yarn add / pip install ...
* [ Select your base image ](https://hub.docker.com)

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
# Creates a docker image
docker build -tag docker-image-name .

# Removes a docker image
docker rmi docker-image-name
```

### Run docker
* Either run with docker or docker-compose

```bash
#Run your docker
docker run docker-image-name

# Run / interactive / allocate pseudo-TTY / remove when it exits
docker run --rm -it docker-image-name
```








### Installing node/npm using NVM

### For Node/NPM in docker `./scripts/node.sh`

```sh
set -e

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")

source $NVM_DIR/nvm.sh
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default

npm install -g npm@"$NPM_VERSION"
npm install -g gulp bower
```
