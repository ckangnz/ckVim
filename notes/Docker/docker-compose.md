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

```bash
docker-compose build
docker-compose run --rm web bash
docker-compose up
```
