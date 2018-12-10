# Docker Compose

* Before proceeding, **you must download Docker**

### Create a `docker-compose.yml`

```docker
version: '3'
services:
  web:
    build: ./
    ports:
    - "8000:80"
    volumes:
    - "./:/app:rw"
    - "./data:/data:rw"
    depends_on:
    - db
    links:
    - "db:postgres"
    command: python manage.py runserver 0.0.0.0:80
    env_file: .env-local
  db:
    image: postgres:9.4
    volumes:
    - ".:/app:rw"
```

###### web

* `build`: build it from the Dockerfile in the parent directory
* `links`: link to the database container
* `ports`: map the external port 8000 to the internal port 80
* `volumes`:
  * map the parent directory on the host to /app in the container, with read and write access
  * map the data directory on the host to /data in the container, with read and write access
* `command`: by default, when the command docker-compose run is issued, execute python manage.py runserver 0.0.0.0:80
* `env_file`: use the .env-local to supply environment variables to the container

###### db
* `image`: build the container from the `postgres:9.4` image
* `volumes`: map the parent directory on the host to /app in the container, with read and write access


```bash
docker-compose build
docker-compose run --rm web bash
docker-compose up
```
