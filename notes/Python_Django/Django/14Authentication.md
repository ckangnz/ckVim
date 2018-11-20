# Authentications
* Include `django.contrib.auth` and `django.contrib.contenttypes` in `INSTALLED_APPS`

## Passwords
* Never store passwords as plain text!
* By default, Django uses PBKDF2 algorithm with a SHA256 hash
  * www.xorbin.com/tools/sha256-hash-calculator

### Install bcrpyt and django[argon2]
```bash
pip install bcrypt django[argon2]
```

### Edit `settings.py`

```python
...
PASSWORD_HASHERS = [
  'django.contrib.auth.hashers.Argon2PasswordHasher',
  'django.contrib.auth.hashers.BCryptPasswordHasher',
  'django.contrib.auth.hashers.BCryptSHA256PasswordHasher',
  'django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher',
  'django.contrib.auth.hashers.PBKDF2PasswordHasher',
]
AUTH_PASSWORD_VALIDATORS = [ #Automatically generated. Edit this if neccessary ]
...
```
* Read https://docs.djangoproject.com/en/1.11/ref/settings/#auth-password-validators for more configurations

### User Model
* You import `User` model and extend in first_app > `models.py`

```python
#models.py
from django.db import models
from django.contrib.auth.models import User

class UserProfileInfo(models.Model):
  user = models.OneToOneField(User)

  portfolio = models.URLField(blank=Truej
  profile_pic = models.ImageField(upload_to='profile_pics') #will require enctype="multipart/form-data" on form

  def __str__(self):
    return self.user.username
```

### Forms
```python
# forms.py of first_app

from django import forms
from djagno.contrib.auth.models import User
from first_app.models import UserProfileInfo

class UserForm(forms.ModelForm):
  password = forms.CharField(widget= forms.PasswordInput())

  class Meta():
    model = User
    fields = ('username','email','password')

class UserProfileInfoForm(forms.ModelForm):
  class Meta():
    model = UserProfileInfo
    fields = ('portfolio_site', 'profile_pic')
```

### Register on admin.py
```python
admin.site.register(UserProfileInfo)
```

### views.py example
```python
def register(request):
    registered = False
    if request.method == "POST":
        user_form = forms.UserForm(request.POST)
        profile_form = forms.UserProfileInfoForm(request.POST)
        if user_form.is_valid and profile_form.is_valid:
            user = user_form.save()
            user.set_password(user.password)
            user.save()

            profile = profile_form.save(commit=False)
            profile.user = user

            if 'profile_pic' in request.FILES:
                profile.profile_pic = request.FIlES['profile_pic']
            profile.save()
            registered=True
            return index(request)

        else :
            print(user_form.erros, profile_form.errors)

    else :
        user_form = forms.UserForm()
        profile_form = forms.UserProfileInfoForm()

        return render(request,"basic_app/register.html", {'user_form':user_form, 'profile_form':profile_form})
```
