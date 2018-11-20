# Template Inheritance

* Find the repetitive parts of your project
* Create a base template of them
* Set the tags in the base template
* Extend and call those tags anywhere

```html
<!--base.html-->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>
      {% block title %}
        {% page_attribute "page_title" %} | {{request.site.name }}
      {% endblock %}
    </title>
  </head>
  <body>
    {% block content %}{% endblock %}
  </body>
</html>
```

```html
<!--other.html-->
{% extends 'base.html' %}
{% block content %}
  <h1>HI</h1>
{% endblock %}
```
