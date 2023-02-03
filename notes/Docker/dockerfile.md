# Use Dockerfile to build the Docker Image!

- Dockerfile will create an image when we build.
- An image should contain libraries for app to run properly.
  - npm install / yarn add / pip install ...
- Good practice
  - EXPOSE - port information
  - ENV - environment variables
  - VOLUME - data location
  - LABEL,MAINTAINER, …
- [ Select your base image ](https://hub.docker.com)

## Build Image with dockerfile

```bash
Docker build
  -t name:tag
  -f ./Dockerfile .

# Example
Docker build -t demo:1.0.0 -f ./Dockerfile .
```

### Dockerfile

##### Node Example

```Dockerfile
FROM node:10.40.0-alpine
WORKDIR /usr/src/app
COPY package*.json /usr/src/app
RUN npm install
COPY . /usr/src/app
CMD[ "npm", "Start" ]
```

##### Python Example

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

```dockerfile
*.pyc
*.pyo
/node_modules
...
```

## Add user

```dockerfile
…
RUN addgroup --gid 15555 notroot \
    && adduser --uid 15555 -G notroot --g "" -D -s /bin/false notroot
…
USER notroot
```

## Build and Run

```dockerfile
# BUILD STAGE
FROM maven AS build
…

# RUN STAGE
FROM openjdk.alpine
COPY --from=build /usr/app/target/something.jar something.jar
EXPOSE 8080
ENTRYPOINT["java","-jar","-Xms256m", "-Xmx512m", "/something.jar"]
```
