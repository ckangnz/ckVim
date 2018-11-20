# Customize Admin Page

### Customizing the templates
* Edit templates from this directory : https://github.com/django/django/tree/master/django/contrib/admin/templates/admin
```bash
/templates/admin/
```

## Edit admin.py for followings :

### Customizing the default field ordering

```python
class ModelOneAdmin(admin.ModelAdmin):
  fields = ['field3', 'field2', 'field5']

admin.site.register(models.ModelOne, ModelOneAdmin)
```

### Search function

```python
  search_fields = [ 'field1' ]
```

### Filtering fields

```python
  list_filter = [ 'field1' ]
```

### Adding more fields on list page

```python
  list_display = [ 'field1' ]
```

### Editing on list view

```python
  list_editable = [ 'field1' ]
```
