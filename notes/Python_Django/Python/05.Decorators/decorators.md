# Decorators

## This is a general function
```python
s = "This is global variable"
d = "This is global variable 2"
def func():
  global s
  s = "Global s is changed to this now"

  d = "This is local. Not affecting the global d"

  print(locals())
  print(globals())

func()
```

## Functions within functions
```python
def hello(name="Chris"):
  print("HI")

  def greet():
    print("Nice to meet you")

  def welcome():
    print("Welcome!")

  if name == "Chris":
    greet()
  else:
    welcome()
  
x = hello
x()
```

## Functions called within function
```python
def hello():
  return "HI"

def other(func):
  print(func())

other(hello)
```

## Decorator
```python
def new_decorator(func):

  def wrap_func():
    print("CODE HERE BEFORE EXECUTING FUNC")
    func()
    print("FUNC() has been called")
  return wrap_func

def func_needs_decorator():
  print("This function is in need of a decorator!")

func_needs_decorator = new_decorator(func_needs_decorator)
```
Above example can become like this:
```python
def new_decorator(func):

  def wrap_func():
    print("CODE HERE BEFORE EXECUTING FUNC")
    func()
    print("FUNC() has been called")
  return wrap_func

@ new_decorator
def func_needs_decorator():
  print("This function is in need of a decorator!")
```
