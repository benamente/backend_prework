## Day 4 Questions

1. In your own words, what is the purpose of a method?  

A method allows you to generalize your code. This means you don't have to write the same, or similar, code blocks over and over again. It also means that while certain areas of code can get into nitty gritty details, other areas of code can do more big picture stuff by calling that other code.

1. In the space below, create a method named `hello` that will print `"Sam I am"`.

```ruby
def hello
  puts "Sam I am"
end
```

1. Create a method name `hello_someone` that takes an argument of `name` and prints `"#{name} I am"`.

```ruby
def hello_someone(name)
  puts "#{name} I am"
```

1. How would you call or execute the method that you created above?

`hello_someone("Ben")`  

1. What questions do you still have about methods in Ruby?  

I was looking online for a complete list of methods that cause mutation inside of methods, couldn't find one.  push, pull, and most with exclamation points, is my working list.  

I was also wondering if there's a way that you can get a custom method to modify one or more of its arguments. You can usually get around this in situations where you need it by having the method returning an array... for example if you were to write a custom pop method you would have to have it return [the_popped_off_part, the_leftover] or something like that. What I've read online makes me think that's our only option. But it'd be good to know if that's right or not.

I'm also curious about passing in code blocks in as an arguments into a method, using `yield`. I read about it a little, but haven't practiced it much. What are ideal cases for structuring code like this?
