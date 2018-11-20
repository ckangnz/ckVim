# Faker Library
```python
pip install Faker
```

## Create a file `populate_first_app.py`
Configuring the settings for the project before manipulating the model
```python
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'first_project.settings')

import django
django.setup()
```

```Python
## FAKE POP SCRIPT
import random
from first_app.models import ModelOne, ModelTwo
from faker import Faker

fakegen = Faker()
fake_values = ['Value', 'Value2', 'Value3']

#Simple
def add_value():
  v = ModelOne.objects.get_or_create(fieldname=random.choice(fake_values))[0]
  v.save()
  return v

def populate(N=5):
  for entry in range(N):
  val = add_value()
  fake_url = fakegen.url()
  fake_date = fakegen.date()
  fake_name = fakegen.company()

  # Apply fakers to model
  new = ModelTwo.objects.get_or_create(fieldname=val, fieldname2=fake_url, fieldname3=fake_name ...)

if __name__ == '__main__':
  print("populating script!")
  populate(20)
  print("populating complete!")
  ```
