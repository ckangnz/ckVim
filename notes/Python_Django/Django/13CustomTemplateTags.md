## Custom Template Filters

* You must create a folder `templatetags` in the application folder
* Create `\_\_init__.py` in `templatetags` folder.

```
first_app
  __init__.py
  models.py
  templatetags/
    __init__.py
    custom_template_name.py
  views.py
```

* Custom Template Python file

```python
from django import template

register = template.Library()

def cut(value,arg):
  """Removes arg from value"""
  return value.replace(arg, '')

register.filter('cut',cut)

#OR

@register.filter(name='cut')
def cut(value,arg):
  """Removes arg from value"""
  return value.replace(arg, '')

```

* Template filters that expect strings

```python
from django import template
from django.template.defaultfilters import stringfilter

@register.filter
@stringfilter
def lower(value):
  return value.lower()
```

* This custom templates can be used in templates by loading

```html
{% load custom_template_name %}
{{ text|cut:"thisword" }}
{{ text|lower }}
```
