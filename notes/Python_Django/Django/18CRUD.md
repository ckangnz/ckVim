# CRUD : Create / Retrieve / Update / Delete

## CreateView Class

```python
class SchoolCreateView(CreateView):
    model = models.School
    fields = ('name', 'principal', 'location')
    #template_name = "basic_app/school_form.html" by default
```

* Requires get_absolute_url in models.py

```python
# from django.core.urlresolvers import reverse //deprecated
from django.urls import reverse
...

class School(models.Model):
  ...
  def get_absolute_url(self):
    return reverse("basic_app:detail", kwargs={'pk':self.pk})
```

## UpdateView Class

```python
class SchoolUpdateView(UpdateView):
    model = models.School
    fields = ('name','principal')
```
## DeleteView Class

```python
from django.urls import reverse_lazy

class SchoolDeleteView(DeleteView):
    model = models.School
    success_url = reverse_lazy("basic_app:list")
    #context_object_name = 'school' by default
    #template_name = "basic_app/school_confirm_delete.html" by default
```

## RedirectView Class
```python
from django.urls import reverse

class SomeRedirectView(RedirectView):
  def get_redirect_url(self,*args,**kwargs):
    return reverse("basic_app:detail", kwargs={'pk':self.pk})
```

### If Login is required for CBV:
```python
from django.contrib.auth.mixins import LoginRequiredMixin

class CreateView(LoginRequiredMixin, CreateView):
  login_url = '/login/' #where to login?
  redirect_field_name = 'name_of_the_template.html' # redirect to this template
  form_class = FormName #Import this form
```

## _form.html template can be used for create/update
```html
{% if not form.instance.pk %}
    Create 
{% else %}
    Update
{% endif %}
```
