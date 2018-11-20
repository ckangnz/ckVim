# Static Files

## Create a static folder
```bash
mkdir static/images
```
## Edit settings.py
```python
STATIC_DIR = os.path.join(BASE_DIR,'static')
#STATIC_DIR is /static

STATIC_URL='/static/'
STATICFILES_DIRS = [
  STATIC_DIR,
]
```
* Now we can reference to `localhost:8000/static/images`
### We can use this in our templates.
```html
{% load staticfiles %}
{% static 'images/dog.jpg' %}
```

* We can also create folders `css` or `js` in static folder
```html
<link rel="stylesheet" href="{% static "css/style.css" %}">
```

# Media Files

## Create a media folder
```bash
mkdir media
```

## Edit settings.py
```python
MEDIA_DIR = os.path.join(BASE_DIR, 'media')
...
MEDIA_ROOT = MEDIA_DIR
MEDIA_URL = '/media/'
```
