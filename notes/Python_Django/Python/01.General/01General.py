# Formatting
formatted_string = "string can have a variable {a} like so {b}".format(a=".", b=". Tada!")
print(formatted_string)
# Slicing
print(formatted_string[5:])
print(formatted_string[:5])
print(formatted_string[1:4])
# Skipping
print(formatted_string[::2])

# DICTIONARIES
# Unordered elements (like objects)
# key : value
my_lunch = {'lunch':'pizza', 'breakfast':'eggs'}
# Reassign
my_lunch['lunch']='burger'
# Add
my_lunch['dinner'] = 'pasta'
print(my_lunch)
print(my_lunch['lunch'])

# TUPLES
# Immutable array
list = ('tupleOne',2,3)
print(list[0])

# SETS
# Unordered of UNIQUE elements
my_set = set()
my_set.add(1)
my_set.add(2)
my_set.add("this is a set")
print(my_set)

# CONDITIONS IN PYTHON
if 1 == 1 :
    print("true")
elif 1 != 1 :
    print("elif true")
else :
    print ("else")

# FOR LOOP (Kind of foreach)
my_seq = [1,2,3,4,5,6]
for item in my_seq:
    print(item)
for item in my_lunch:
    print(item)
    print(my_lunch[item])
# Tuple Unpacking
tuples = [(1,2),(3,4),(5,6)]
for t1,t2 in tuples:
    print(t1)

# FOR LOOP
for item in range(10):
    print(item)

# WHILE LOOP
i = 1
while i < 3:
    print("i is : {}".format(i))
    i = i+1

# FOR LOOP COMPREHENSION
x= [1,2,3,4]
out = []
for num in x :
    out.append(x*2)
# OR
out = [num*2 for num in x]
print(out)

