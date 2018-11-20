# Model Forms

### This is to generate a form using the model fields

## Create `forms.py` inside application

```python
from django import forms
from . import models

class model_form(forms.ModelForm):
  class Meta:
    model = models.ModelOne
    fields = "__all__"
    #fields = ('field1', 'field2')
    #exclude = ['field1', 'field2']

    widgets = {
      'field1': forms.TextInput(attrs={'class':'className'}),
      'field2': forms.Textarea(attrs={'class':'className2'}),
      ...
    }
```

