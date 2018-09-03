## Day 6 Questions

1. In your own words, what is a Class?  

A Class (always in capitalized CamelCase) is a sort of like a category of object. Inside it's definition are its methods and attributes. It can be derived or inherited from other Classes.  

1. In relation to a Class, what is an attribute?

An attribute is a value that you assign to an object of the Class. For example the object my_tree of the Tree class would have the attribute height.  

1. In relation to a Class, what is behavior?  

A behavior is a method that the object can do. For example, members of the Tree class might have a behavior called grow. To get my_tree to grow, we would call my_tree.grow.  

1. In the space below, create a Dog class with at least 2 attributes and 2 behaviors  

```ruby
class Dog
  attr_accessor :breed, :age

  def initialize(breed, age)
    @breed = breed
    @age = age
    @speed
  end

  def eat
    $food -= 10
  end

  def run
    @speed = 10
  end
end
```

1. How do you create an instance of a class?
```ruby
object_variable = ClassName.new(argument1, argument2)
```
1. What questions do you still have about classes in Ruby?  

I'm not sure if I understand what a class method is and how/if it's different
from a behavior. I'm going to go read Classes and Objects -- Part II on launch school to investigate.
