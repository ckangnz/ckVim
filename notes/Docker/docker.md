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

COPY requirements.* ./
RUN pip install --no-cache-dir -r requirements.*

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
