# Model

* We use Models to incorporate a database into a Django Project
* Django comes equipped with SQLite
* We edit `models.py` of an application to store data

## Edit models.py of the application
```python
from django.db import models

class ModelOne(models.Model):
  fieldname = models.CharField(max_length = 264, unique = True)

  def __str__(self):
    return self.fieldname

class ModelTwo(models.Model):
  model_one = models.Foreignkey(ModelOne)
  url = models.URLField(unique=True)
  picture = models.ImageField(upload_to='subfolder') #need to create dir in /media/

  def __str__(self):
    return self.url
```
* To use ImageField, `pillow`is required
```bash
pip install pillow
```

## Migration
```bash
python manage.py migrate
python manage.py makemigrations first_app
python manage.py migrate
```

## Edit admin.py to use Admin Interface
```python
from django.contrib import admin
from first_app.models import ModelOne, ModelTwo

admin.site.register(ModelOne)
admin.site.register(ModelTwo)
```

## Make Superuser
* We can create the first user account by this command
```bash
python manage.py createsuperuser
```

## Go to `localhost:8000/admin`
