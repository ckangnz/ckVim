# PYTHON USES SNAKECASE
def my_func(param1 = 'default'):
    """
    This is a doc string
    """
    print('my first python function {}'.format(param1))

my_func()


# FILTER
mylist = [1,2,3,4,5]

def even_bool(num):
    return num % 2 == 0

evens = filter(even_bool, mylist)
print(evens)

# LAMBDA EXPRESSION
# Anonymous function
evens = filter(lambda num: num % 2 == 0, mylist)
print(evens)

# Checking if array consists value
print('x' in [1,2,3,4,'x'])
