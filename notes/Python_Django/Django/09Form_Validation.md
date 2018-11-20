# Form Validation

### Edit `forms.py`

```python
from django import forms

class FormName(forms.Form):
  ...
  fieldname = forms.CharField(required=False, widget = forms.HiddenInput)

  # Manual Validation
  def clean_fieldname(self):
    error = self.cleaned_data['fieldname']
    if len(error) > 0 :
      raise forms.ValidationError("GOTCHA!!")
```

### OR DJango's default validator

```python
from django import forms
from django.core import validators

class FormName(forms.Form):
  ...
  fieldname = forms.CharField(required=False, widget = forms.HiddenInput, validators = [validators.MaxLengthValidator(0)])
```

### Custom validator

```python
def check_for_z(value):
  if value[0].lower() != 'z':
    raise forms.ValidationError("NAME NEEDS TO START WITH Z")

class FormName(forms.Form):
  ...
  fieldname = forms.CharField(required=False, widget = forms.HiddenInput, validators = [ check_for_z ])
```

### Example
```python
class FormName(forms.Form):
  email = forms.EmailField()
  verify_email = forms.EmailField(label="Enter your email again:")

  def clean(self):
    all_clean_data = super().clean()
    email = all_clean_data['email']
    vemail = all_clean_data['verify_email']
    if email != vemail:
      raise forms.ValidationError("Email not macthing")
  ```
