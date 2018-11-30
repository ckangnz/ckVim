# Install Postgres on your mac

```bash
brew install postgresql

#after installing, load postgres when your computer starts up
pg_ctl -D /usr/local/var/postgres start && brew services start postgresql
#check version
postgres -V

#start postgres by :
psql postgres
# or 
psql postgres -U `username`
```

>POSTSQL

```bash
# Show a table of userlist
\du
# Create user (optional)
CREATE ROLE username WITH LOGIN PASSWORD 'xxxxxx';
ALTER ROLE username CREATEDB;

# Create database
CREATE DATABASE databasename;
GRAND ALL PRIVILEGES ON DATABASE databasename TO username
ALTER DATABASE databasename TO otherdatabasename;

# Connect to database
\connect databasename
```

>BASH

```bash
createuser username --createdb
createdb databasename -U username
```

## Install Postgresql on pip list

```bash
pip install psycopg2
```

> Change settings.py

```py
#FROM 
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

#To
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'NAME_OF_DB',
        'USER': 'DB_USER_NAME',
        'PASSWORD': 'DB_PASSWORD',
        'HOST': 'localhost',
        'PORT': 'PORT_NUMBER',
    }
}
```

> Makemigrations then migrate

### Backing up the data

```bash
python manage.py dumpdata > db.json
python manage.py loaddata db.json
```
