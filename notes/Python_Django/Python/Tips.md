# Python tips

### Printing objects to console

```python
print(ObjectName)
# returns <Object object>

pring(dir(ObjectName))
# returns lists in object
```

### Methods in Classes (using self and super)
```python
class ClassName():
  some_text = "Text"

  def methodWithinClass():
    return some_text

  def methodUsedOutOfClass(self):
    return some_text

class SubClassName(ClassName):
  
  def returnSomeText(self):
    #super() == parent class
    #python3
    return super().methodUsedOutOfClass()
    #python2
    return super(SubClassName, self).methodUsedOutOfClass()

myClass = SubClassName()
myClass.returnSomeText()
```
