# Templates
* We need to teach Django to use templates directory
* first_project/templates/first_app/*.html

1. Create `templates` folder on root directory.
2. In settings.py
```python
TEMPLATE_DIR = os.path.join(BASE_DIR,'templates')
#TEMPLATE_DIR is "/templates"
...
TEMPLATES = [
  {
    'DIRS': [ TEMPLATE_DIR, ],
  }
]
```
3. Create a folder `first_app` folder in `templates`
4. Create HTML file in `first_app` folder e.g. index.html
5. Edit views.py

```python
def index(req):
  abc = {'abc' : "this is the actual value of abc"}
  return render(req, 'first_app/index.html', context=abc)
  #return HttpResponse("hello world!")

#Class Based View
from django.views.generic import View, TemplateView

class IndexView(View):
  def get(self,request):
    return HttpResponse("CLASS BASE IS COOL")
```
