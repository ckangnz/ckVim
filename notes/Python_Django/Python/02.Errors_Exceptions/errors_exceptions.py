# Try Except Finally

try:
    f = open('test.txt', 'w')
    f.write("Test write to simple text!")
except:
    print("ERROR: COULD NOT FIND FILE OR READ DATA!")
else:
    print("SUCCESS")
finally:
    print("THIS WILL ALWAYS PRINT")
    f.close()
