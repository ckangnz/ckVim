# Starting
* Start virtualenv
```
 mkvirtualenv --python=python3.5 environmentName
```
* Install django
```bash
pip install django django-admin
pip install django==1.11
```
* Install Project with this command
```bash
django-admin startproject project-name
```
This will create followings:
* \_\_init__.py
  * This is a blank Python script that due to its special name let's Python know that this directory can be treated as a package
* settings.py
  * Settings of the project
* urls.py
  * URL patterns for the project.
* wsgi.py
  * Web Server Gateway Interface.
  * Helps to deploy web app to production.
* manage.py
  * Associates with many commands to 'build' our app!

## Run Server
```bash
python manage.py runserver
```
---

## Django Application
* A __Django Project__ is a collection of _applications_ and _configurations_ that when combined together will make up the __full web application__.
* A __Django Application__ is created to perform a particular functionality for your entire web application. E.g. Registration app, Polling app, Comments app etc.

### Creating a simple Django Application
```bash
python manage.py startapp first_app
or
django-admin startapp first_app
```
This will create followings:
* admin.py
  * Register models to Django's admin interface.
* apps.py
  * Application specific configurations
* models.py
  * Store application's data models
* tests.py
  * Store test functions to test your code
* views.py
  * handles requests and return responses

### Add to settings.py
```python
INSTALLED_APPS=[
  ...
  'first_app',
  ...
]
```

### Edit views.py of first_app
```python
from django.http import HttpResponse

def index(request):
  return HttpResponse("hello world!")
```

### Edit urls.py of first_project
```python
from django.conf.urls import url
from django.conf.urls import path
from first_app import views

urlpatterns = [
  ...
  url(r'^$', views.index, name='index'),

  #Class Based View
  path('', views.index.as_view(), name="index"),
  ...
]
```

### Make sure to freeze pip packages in requirements.in
```bash
pip freeze > requirements.in
```
