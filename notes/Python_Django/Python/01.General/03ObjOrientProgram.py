class Circle:
    # CLASS OBJECT ATTRIBUTE
    pi = 3.14

    def __init__(self, radius = 1):
        self.radius = radius

    def area(self):
        return self.radius * self.radius * Circle.pi

    def set_radius(self, new_r):
        self.radius = new_r

myc = Circle(3)
print(myc.area())
myc.radius = 100
print(myc.area())
myc.set_radius(999)
print(myc.area())


class Animal:
    def __str__(self):
        return "Animal Class"
    def __init__(self):
        print("ANIMALL INITIALISED")
    def what_am_i(self):
        print("I'm an animal")
    def sound(self):
        print("???")


class Dog(Animal):
    def __str__(self):
        return "Dog Class"
    def __len__(self):
        return 12 
    def __del__(self):
        print("DOG IS DELETED")
    def __init__(self):
        print("DOG INITIALISED")
    def sound(self):
        print("WOOF")

myDog = Dog()
myDog.what_am_i()
myDog.sound()
print(myDog)
print(len(myDog))
del myDog
