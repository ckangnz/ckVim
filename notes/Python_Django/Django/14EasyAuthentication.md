# Easy Authentication (Sign Up)

###  Project views.py

```python
from django.views.generic import TemplateView

class HomePage(TemplateView):
    template_name = 'index.html'

class LoggedIn(TemplateView):
    template_name = 'loggedin.html'

class ThanksPage(TemplateView):
    template_name = 'thanks.html'
```

### Project urls.py

```python
from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),

    path('', views.HomePage.as_view(), name="home"),
    path('loggedin/', views.LoggedIn.as_view(), name="loggedIn"),
    path('thanks/', views.ThanksPage.as_view(), name="thanks"),

    path('accounts/', include('accounts.urls', namespace='accounts')),
    path('accounts/',include('django.contrib.auth.urls')),
]
```

### Account views.py

```python
from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

app_name = 'accounts'

urlpatterns = [
    path('login/', auth_views.LoginView.as_view(template_name='accounts/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('signup/', views.SignUp.as_view(), name='signup'),
]
```

### Account urls.py

```python
from django.shortcuts import render
from django.urls import reverse_lazy
from django.views.generic import CreateView
from . import forms

# Create your views here.
class SignUp(CreateView):
    form_class = forms.UserCreateForm
    success_url = reverse_lazy('login')
    template_name = "accounts/signup.html"
```

### Account models.py

```python
from django.db import models
from django.contrib import auth

class User(auth.models.User, auth.models.PermissionsMixin):
    def __str__(self):
        return "@{}".format(self.username)
```

### Account forms.py

```python
from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm

#Show only wanted fields from default RegisterForm
class UserCreateForm(UserCreationForm):
    class Meta:
        fields = ('username', 'email', 'password1', 'password2')
        model = get_user_model()

    def __init__(self, *args, **kwargs):
        super().__init__(*args,**kwargs)
        self.fields['username'].label = "Display Name"
        self.fields['email'].label = "Email Address"
        self.fields['password1'].label = "Password"
        self.fields['password2'].label = "Confirm Password"
```


## settings.py
```python
...
LOGIN_REDIRECT_URL = 'loggedIn'
LOGOUT_REDIRECT_URL = 'thanks'
...
```
