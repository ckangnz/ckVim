# Login and Logout

## Easy Custom Super User Login Page (Super User Only)

* Edit urls.py

```python
from django.contrib.auth import views

urlpatterns = [
  path('account/login/', views.login, name='login'),
  path('account/logout/', views.logout, name='logout', kwargs ={'next_page':'/'})

  #Django 2.x
  path('accounts/', include('django.contrib.auth.urls')),
]
```

* Add templates with a form 

```html
{% if form.errors %}
  <p>username / password not matched!</p>
{% endif %}
<form action="{% url 'login' %}" method="POST">
  {% csrf_token %}
  {{ form.as_p }}
  <input type="submit" value="login">
  <input type="hidden" name="next" value="{{next}}">
</form>
```

## Custom Login Page

* Edit settings.py
```python
...
LOGIN_URL = '/basic_app/login/'
```

* Login html
```html
<form action="{% url 'basic_app:login' %}" method="post">
    {% csrf_token %}
    <label for="username">Username:</label>
    <input type="text" name="username" id="username"/>

    <label for="password">Password:</label>
    <input type="password" name="password" id="password"/>

    <input type="submit" value="Login" name="submit" id="submit"/>
</form>
```
* Checking logged in or not

```html
{% if user.is_authenticated %}
```

* Edit views.py

```python
#Import
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect, HttpResponse
from django.urls import reverse
from django.contrib.auth.decorators import login_required

def user_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        user = authenticate(username=username, password=password)

        if user:
            if user.is_active:
                login(request,user)
                return HttpResponseRedirect(reverse('index'))
            else :
                return HttpResponseRedirect("ACCOUNT NOT ACTIVE")
        else :
            print("Someone tried to login and failed!")
            print("Username: {} and password {}".format(username, password))
            return HttpResponse("invalid login details!")
    else :
        return render(request, 'basic_app/login.html', {})

@login_required
def user_logout(request):
    logout(request)
    return HttpResponseRedirect(reverse('index'))
```
