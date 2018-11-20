# Relative URLS with Templates

```html
<!--BAD-->
<a href="first_app/thankyou"></a>
<!--GOOD-->
<a href="{% url 'thankyou' %}"></a>
<a href="{% url 'first_app:thankyou' %}"></a>
```

## Edit urls.py
```python
from first_app import views

#This sets the name of the Relative Url
app_name = 'first_app_name'

urlpatterns=[
  url(r'^page1/$', views.index, name="index")
  url(r'^page2/$', views.otherpage, name="otherpage")
]
```

## Edit templates
```html
<a href="{% url 'first_app_name:index' %}">Index of First app</a>
<a href="{% url 'admin:index' %}">Admin Page</a>
<a href="{% url 'index' %}">Home</a>
```
