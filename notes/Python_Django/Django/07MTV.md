# Model Templates Views
1. In the views.py file, we import any models that we will need to use.
2. Use the view to query the model for data that we will need
3. Pass results from the model to the template
4. Edit the template so that it is ready to accept and display the data from the model.
5. Map a URL to the view.

* Edit views.py
```python
from first_app.models import ModelOne, ModelTwo
#Load models
...
def index(request):
  list = ModelOne.objects.order_by('fieldname')
  #Load data from the model
  data = {'variable_name': list}
  return render(request, 'template.html', context = data)
```
