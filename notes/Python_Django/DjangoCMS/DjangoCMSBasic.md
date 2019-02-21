# Divio-cli
```bash
divio doctor                    "Check Status"
divio project 
    up                          "Start virtual env"
    stop                        "Stop virtual env"
    push/pull /db/media (live)  "Push or pull data/media from test or live"
    update                      "Update local project files from live"
    deploy                      "Deploy local project files TO test"
    open/test/live              "Open browser for local/test/live server"
    dashboard                   "Open browser for dashboard"
    list                        "Show lists of projects"
```

# Docker
```bash
docker-compose
    up                          "start web and db --> Starts logs"
    build                       "Rebuild the project to install new package after adding in requirements.in"
    run --rm web bash           "start web --> Starts docker virtualenv in bash"
    exec web bash               "bash in existing web"
        gulp                    
        npm install
```

## Create an application
1. In docker container :
    python manage.py startapp `app-name`

2. Create Model
3. (Optional) Create CMS Toolbars
4. Create Admin model

5. Make migrations
    python manage.py makemigrations `app-name`

6. Migrate the app to database
      python manage.py migrate `app-name`

## Locale

```bash
docker-compose run web bash python manage.py
  makemessages -a       "Creates all locale language translations automatically"
```


## Migrate
```bash
docker-compose run -rm web bash # Start a container

python manage.py
  makemigrations      #Making migration files
      --merge         #Merge onto existing migration file
  migrate             #Migrate the new model
     --fake `appname` zero   #Unapply migrations 
      --fake-initial  #Faking migration to be initial
```

## Resetting Migration
  1. Unapply migration of the app
  - `python manage.py migrate --fake "APPNAME" zero`
  2. Delete all in migrations folder except __init__
  - `find . -path "APPNAME/migrations/*.py" -not -name "__init__.py" -delete`
  - `find . -path "APPNAME/migrations/*.pyc" -delete`
  3. Create the initial migrations
  - `python manage.py makemigrations "APPNAME"`
  4. Fake the initial migration
  - `python manage.py migrate "APPNAME" --fake-initial`

# Installing Plugin
    * In docker-compose
        * pip install *plugin*
        * Configure INSTALLED_APPS.extend in settings.py
        * Configure URLs in urls.py
        * Migrate the database by running

    * Pip Usage
        * pip install --upgrade pip(or other package names)
        * pip list
        * pip freeze > ???.txt
        * pip install -r ???.text

# Navigation
    * show_menu
        * start_level - default = 0 (e.g. change to 1 to hide first nav item)
        * end_level - default = 100
        * extra_inactive - default = 0
        * extra_active - default= 100 
        * namespace - 
        * root_id - specifies the id of the root node
        * template


# Printing all variables
> In models.py

```python
def get_fields(self):
  return [(field.name, field.value_to_string(self)) for field in MODELNAME._meta.fields]
```

> In Template

```python
{% for name, value in instance.field_name %}
  {% if value %}
      {{ name }} => {{ value }}
  {% endif %}
{% endfor %}
```
