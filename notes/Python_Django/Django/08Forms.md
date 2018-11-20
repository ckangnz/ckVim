# Django Forms
## Advantages
* Quickly generate HTML form widgets
* Validate data and process it into a Python data structure
* Create form versions of our Models, quickly update models from Forms

## Create `forms.py` inside application

```python
from django import forms

BIRTH_YEAR_CHOICES = ('1980', '1981', ...)
class FormName(forms.Form):
  name = forms.CharField()
  email = forms.EmailField()
  verify_email = forms.EmailField(label="Enter your email again:")
  text = forms.CharField(widget=forms.Textarea)
  date = forms.CharField(widget=forms.SelectDateWidget(years=CHOICES))
  radio_select = forms.CharField(widget=forms.RadioSelect, choices=CHOICES)
```

## Add form view in  `views.py`

```python
from . import forms

def form_name_view(req):
  form = forms.FormName()

  if req.method == 'POST':
    #This is when the view is returned with a submit
    form = forms.FormName(req.POST)

    if form.is_valid():
      form.save(commit=True)
      return (index(req))

  return render(req, 'first_app/form_name.html', {'form':form})
```

## Edit the `urls.py`

```python
from django.conf.urls import url
from first_app import views

urlpatterns = [
  url(r'^formpage/', views.form_name_view, name='form_name')
]
```

## Create and edit `first_app/form_name.html`
```html
  <form method="POST">
    {% csrf_token %}
    {{ form.as_p }}
    <input type="submit" name="submit" value="Submit">
  </form>
```

## csrf_token
* Cross-Site Request Forgery (CSRF) token secures the HTTP POST action that is initiated on the subsequent submission of a form
* Django forms must have csrf token

----------------------------------------------------------

## HTTP
* Hypertext Transfer Protocol is designed to enable communication between a _client_ and a _server_
* The _client_ submits a `requests` and _server_ `responds`
* The most commonly used methods for this req/res protocol are GET and POST
