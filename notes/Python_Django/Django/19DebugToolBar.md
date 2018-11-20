# Debug Toolbar

```bash
pip install django-debug-toolbar
```

* Edit `settings.py`

```python
...
INSTALLED_APPS = [
  ...
  'debug_toolbar',
  ...
]

MIDDLEWARE = [
  ...
  'debug_toolbar.middleware.DebugToolbarMiddleware',
  ...
]

INTERNAL_IPS = ['127.0.0.1']
```

* Edit `urls.py`

```python
from django.conf import settings

if settings.DEBUG:
  import debug_toolbar
  urlpatterns = [
    url(r'^__debug__/',include(debug_toolbar.urls))
  ] + urlpatterns
```
