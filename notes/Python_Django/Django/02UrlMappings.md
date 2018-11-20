# Url Mapping on each application

### edit urls.py of first_project
```python
from django.conf.urls import url, include

urlpatterns = [
  ...
  url(r'^first_app/', include('first_app.urls')),
  ...
]
```

### create and edit urls.py of first_application
```python
from django.conf.urls import url
from django.conf.urls import path
from first_app import views

urlpatterns = [
    # old
    url(r'^$', views.index, name="index"),
    url(r'^someurl/(?P<pk>\d+)$', views.detailpage, name="detail"),

    # new
    url(r'^$', views.index, name="index"),
    url(r'^someurl/(?P<pk>\d+)$', views.detailpage, name="detail"),

    #class based view
    path('', views.index.as_view(), name="index"),
    path('someurl/<pk>', views.detailpage.as_view(), name="detail"),
]
```
