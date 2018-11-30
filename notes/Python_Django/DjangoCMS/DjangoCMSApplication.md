# Applications
* models.py - Application Model
* urls.py - Application custom url
* views.py - View controller
* admin.py
* urls.py(global) - Global url
* templates - HTML files

# Plugins
* models.py - Plugin Model
* templates - HTML files
* cms_plugins.py - Plugin => CMS connector

# Apphooks
* cms_apps.py - Apphook => CMS connector
* models/views/templates from Application

# CMS Wizards
* forms.py
* cms_wizards.py

# CMS Toolbars
* cms_toolbars.py

# Tests
* tests.py

---

## Creating an Application
* Run python manage.py startapp `app_name`

> urls.py EXAMPLE

```python
from django.conf.urls import url
from . import views

app_name='Application'         #{% url 'Application:index' %}

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^detail/(?P<field_name>\d+)/$', views.detail, name='detail'),
]
```
> urls.py Generic View Version(Update views.py first)

```python
urlpatterns = [
    url('', views.IndexView.as_view(), name='index'),
    url(r'^detail/(?P<field_name>\d+)/$', views.DetailView.as_view(), name='detail'),
    url(r'^detail/(?P<pk>\d+)/$', views.DetailView.as_view(), name='detail'),
]
```

> views.py EXAMPLE

```python
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from .models import ModelName

def index(request):
    item_lists = ModelName.objects.all()
    context = {
        'lists': item_lists,
    #return HttpResponse("Hello, world. You're at the polls index.")#
    return render(request, 'polls/index.html', context)

def detail(request, id):
    #question = get_list_or_404(Model, field_name=value)
    item = get_object_or_404(ModelName, field_name=value)
    return render(request, 'polls/detail.html', {'item': item})
```

> views.py Generic View Version (views as class)

```python
from django.http import HttpResponseRedirect
from django.shortcuts import get_object_or_404, render
from django.core.urlresolvers import reverse
from django.views import generic
from .models import ModelName, ModelName2

class IndexView(generic.ListView):
    model = ModelName OR filtering by: queryset = ModelName.objects.order_by('field_name')[:5]
    context_object_name = 'ModelName_list' (by default)
    template_name = 'app_name/ModelName_list.html'

class DetailView(generic.DetailView):
    model = ModelName OR filtering by: queryset = ModelName.objects.all()
    context_object_name = 'modelname' (by default)
    template_name = 'app_name/ModelName_detail.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['list'] = ModelName.objects.all()
        return context
```

> models.py EXAMPLE

  ```python
from django.db import models
from django.core.urlresolvers import reverse
class ModelName(models.Model):
    title = models.CharField(max_length=200)
    bodytext = models.CharField(max_length=500)
    class Meta:
        verbose_name = "Name you see in admin"
        verbose_name_plural = "custom plural name of this model"
        ordering = ["field_name"]
    def get_absolute_url(self):
        return reverse('app_name:url', kwargs={'slug':self.slug})
    def was_published_recently(self):
        now = timezone.now()
        return now- datetime.timedelta(days=1) <= self.pub_date <= now
    was_published_recently.admin_order_field = 'pub_date'
    was_published_recently.boolean = True
    was_published_recently.short_description = 'Published recently?'
  ```
> admin.py ( Simple ) EXAMPLE

```python
from cms.admin.placeholderadmin import FrontendEditableAdminMixin
from django.contrib import admin
from .models import ModelName

#Add to admin as it is
admin.site.register(ModelName)
```

> admin.py ( Modify Admin option )

```python
class ModelNameAdmin(FrontendEditableAdminMixin, admin.ModelAdmin):
  search_fields=['field_name']
  list_filter=['field_name']
  fields=['fieldname','fieldname']
  actions = ['make_published']
  #OR
  fields[
      ( None ,{'fields':['field_name']}),
      ('Subheader',{'fields':['field_name']}),
      ('Subheader',{'fields':['field_name']}),
  ]

  def make_published(self, request, queryset):
      rows_updated = queryset.update(field_name='value')
      if rows_updated == 1:
          message_bit = "%s story was" % queryset[0].title
      else:
          message_bit = "%s stories were" % rows_updated

      self.message_user(request, "%s successfully marked as published." % message_bit)

  make_published.short_description = "Selected to published"
```

> admin.py ( Multiple models in one admin )

```python
admin.site.register(ModelName, ModelNameAdmin)
#Or two models in one admin option

class ModelName2Inline(admin.TabularInline): OR
class ModelName2Inline(admin.StackedInline):
    model = ModelName2
    extra = 3

class ModelNameAdmin(admin.ModelAdmin):
    fieldsets=['fieldname','fieldname']
    inlines = [ModelName2Inline]

admin.site.register(ModelName,ModelNameAdmin)
```

> global url.py EXAMPLE

```python
url(r'^customURL/', include("app_name.urls")),
```

> Templates

```html
<a href="{% url "app_name:namespace" `id` %}">Link</a>
```
        
## Creating Plugin
* MUST RESTART SERVER AFTER CREATING `CMS_PLUGINS.PY`

> models.py EXAMPLE

```python
from django.db import models
from cms.models import CMSPlugin
from app_name.models import ModelName

class AppPluginModel(CMSPlugin):
    plugin = models.ForeignKey(Model)

    def __unicode__(self):
        return self.poll.question
```

> cms_plugins.py EXAMPLE

```python
from cms.plugin_base import CMSPluginBase
from cms.plugin_pool import plugin_pool
from django.utils.translation import ugettext as _
from app_name.models import AppPluginModel

@plugin_pool.register_plugin
class AppPluginPublisher(CMSPluginBase):
  model = AppPluginModel  # model where plugin data are saved
  module = _("GroupName")
  name = _("Plugin Name")  # name of the plugin in the interface
  render_template = "app_name/plugin.html"
  allow_parent = False
  allow_children = False
  parent_classes = ['ItemColumnCMSPlugin']
  child_classes = [
          'CardCMSPlugin',
          ]

  def render(self, context, instance, placeholder):
      context.update({'instance': instance})
      return context
```

## Creating Apphooks
* MUST RESTART SERVER AFTER CREATING `CMS_APP.PY`
* Either connect `urls.py` or delete it

> cms_apps.py EXAMPLE

```python
from cms.app_base import CMSApp
from cms.apphook_pool import apphook_pool
from django.utils.translation import ugettext_lazy as _
from django.conf.urls import url
from . import views

@apphook_pool.register
class ModelAppHook(CMSApp):
    app_name = "AppName"        #{% url 'AppName:index' %}
    name = _("Polls Application")  #Name you see on apphook dropdown
    supported_apps=('app_name')

    def get_urls(self, page=None, language=None, **kwargs):
        #return ["polls.urls"] #!!REQUIRES URLS.PY if using this!!
        return [
            url('^$', views.index, name='index'),
            url(r'^(?P<slug>[\w-]+)/?$', views.detail, name='detail'),
        ]
```

> Generic View Version(Update views.py first)

```python
return [
    url(r'^detail/(?P<field_name>\d+)/$', views.DetailView.as_view(), name='detail'),
    url(r'^detail/(?P<pk>\d+)/$', views.DetailView.as_view(), name='detail'),
]
```

> HTML EXAMPLE (base.html)

```html
{% extends CMS_TEMPLATE %}
{% block content %}
    `contents`
{% endblock content %}
```

## Creating "Create Button" (CMS_WIZARDS.PY)
* MUST RESTART SERVER AFTER CREATING `FORMS.PY`

> forms.py EXAMPLE

```python
from django import forms
from app_name.models import ModelName

class AppNameForm(forms.ModelForm):
    class Meta:
        model = ModelName
        exclude = []        #exclude 'field_names'
```

> cms_wizards.py EXAMPLE

    ```python
        from cms.wizards.wizard_base import Wizard
        from cms.wizards.wizard_pool import wizard_pool
        from app_name.forms import AppNameForm
        class AppNameWizard(Wizard):
            pass
        app_name_wizard = AppNameWizard(
                title="What you see in Create menu",
                weight=200,
                form=AppNameForm,
                description = "Create a new model"
                )
        wizard_pool.register(app_name_wizard)
    ```

## Creating CMS Toolbar
* MUST RESTART SERVER AFTER CREATING `CMS_TOOLBARS.PY`

> cms_toolbars.py EXAMPLE

```python
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from cms.toolbar_pool import toolbar_pool
from cms.toolbar_base import CMSToolbar
from cms.toolbar.items import Break, SubMenu
from cms.cms_toolbars import ADMIN_MENU_IDENTIFIER, ADMINISTRATION_BREAK
from .models import ModelName

@toolbar_pool.register
class AppToolBar(CMSToolbar):
    watch_models = [ModelName]
    def populate(self):
        if self.is_current_app:
            # ADMIN_MENU_IDENTIFIER is the first menu on tool bar.
            # admin_menu = self.toolbar.get_or_create_menu(ADMIN_MENU_IDENTIFIER)
            admin_menu = self.toolbar.get_or_create_menu('menu-variable',_('Menu Name'))

            #Does this menu already exist?
            position = admin_menu.get_alphabetical_insert_position( _('Weekend Insights'), SubMenu)

            if not position :
                # If not, put this on the first break (or add + 1 for second break)
                position = admin_menu.find_first(Break, identifier = ADMINISTRATION_BREAK)
                # and add another break on the bottom
                # admin_menu.add_break('custom-break', position=position)

            # Create another menu
            menu = admin_menu.get_or_create_menu('weekend-insights-menu',_('Weekend Insights Options'), position = position)

            # Urls are 'admin:app_name_modelname_changelist/change/add/history/delete/' *To Change single file, go views.py
            url = reverse('admin:weekend_insights_weekendinsightsmodel_changelist')
            menu.add_modal_item(_('Weekend Insights List'), url=url)

            # add break on the top
            admin_menu.add_break('insights-break', position=menu)
```

[adding modal options](http://docs.django-cms.org/en/latest/reference/toolbar.html)

>views.py EXAMPLE

```python
from django.core.urlresolvers import reverse

def detail(request, id):
    ...
    menu = request.toolbar.get_or_create_menu('menu-variable',_("Menu Name"))
    menu.add_modal_item(_('Name of the menu'), url=reverse('admin:xxx_xxx_changelist'), args=[id])
```

# Create a test
* Write methods that is likely to cause trouble

> tests.py EXAMPLE

```python
from django.test import TestCase
from .models import ModelName
def create_model(value, value2):
    return ModelName.objects.create(fieldname1= value, fieldname2=value)
class TestFunctionName(TestCase):
    def test_testname_whatever(self):
        create_model('blah', 'blah')
        response = self.client.get(reverse('app_name'))
        self.assertIs(something, true/false);
        self.assertEqual(something, somethingelse);
        self.assertContains(response, somethingelse);
        self.assertQuerysetEqual(response.context['list'], []);
```
* Run python manage.py test ModelName
# How to use shell
* RUN python

```bash
from app_name.models import ModelName
ModelName.objects.all()

from django.utils import timezone
m = ModelName(field="", field2= timezone.now())
m.save()
m.id
```
