# Class Based Views

* Edit `views.py` of first_app

```python
from django.shortcuts import render
from django.views.generic import View, TemplateView
#from django.http import HttpResponse

#Function based view
def index(req):
    return render(req, 'index.html')

#Basic Class based view
class IndexView(View):
  def get(self,request):
    return HttpResponse("CLASS BASE IS COOL")

#TemplateView
class IndexView(TemplateView):
  template_name='index.html'

  def get_context_data(self, **kwargs):
    context = super().get_context_data(**kwargs)
    context['variablename'] = 'value'
    return context
    

```
* Edit `urls.py`

```python
from first_app import views

urlpatterns = [
  url(r'^$', views.IndexView.as_view())
]
```

## Understanding arguments / keyword arguments
* *args / **kwargs
  * Accepts more than one argument
  * *args is a tuple
  * **kwargs is a dictionary (object = unordered)

* _example_

```python
def foo(*args):
  for index, val in *args:
    print('{0}. {1}'.format(index, thing))

foo(1,2,3,4) #returns a tuple 1. 1 2. 2 3. 3 4. 4
foo('apple', 'banana') #returns 1. apple 2.banana

def foo(**kwargs):
  for name, value in kwargs.items():
    print( '{0} = {1}'.format(name,value) )

foo(apple = 'fruit', cabbage = 'vegetable') #returns unordered dictionary: cabbage = vegetable apple=fruit
```
