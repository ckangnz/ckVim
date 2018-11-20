# List and Detail Class Based Views

* Example `models.py`

```python
from django.db import models

class School(models.Model):
    name = models.CharField(max_length=256)
    principal = models.CharField(max_length=256)
    location = models.CharField(max_length=256)

    # Querying
    #def get_queryset(self):
    #  return ModelOne.objects.filter(fieldname__lte=timezone.now().order_by('-fieldname'))

    def __str__(self):
        return self.name

class Student(models.Model):
    name = models.CharField(max_length=256)
    age = models.PositiveIntegerField()
    school = models.ForeignKey(School, related_name='students') #this allows student.students.all()

    def __str__(self):
        return self.name
```

* Create templates within the application folder
```
   /basic_app/templates/basic_app/*.html
```

* ListView and DetailView in `views.py`

```python
...
from django.views.generic import View, TemplateView, ListView,DetailView
from . import models

class SchoolListView(ListView):
  model = models.School
  #template_name="basic_app/school_list.html" by default
  context_object_name = 'schools' # returns school_list by default

class SchoolDetailView(DetailView):
  model = models.School
  #template_name="basic_app/school_detail.html" by default
  context_object_name = 'school' # returns school by default
```

* Edit urls.py

```python
    path('', views.SchoolListView.as_view(), name="list")
    path('detail/<int:id>', views.SchoolDetailView.as_view(), name="detail")
    # in templates : {% url "basic_app:detail" school.id %}
```
