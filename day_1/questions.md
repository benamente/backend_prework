## Day 1 Questions

1. How would you print the string `"Hello World!"` to the terminal?

With `puts "Hello World!"` or `print "Hello World"`

1. What is the character you would use to indicate comments in a ruby file?

An octothorpe, otherwise known as a pound sign or hashtag. `#`

1. Explain the difference between an integer and a float?

A float has a decimal point, an integer doesn't.

1. In the space below, create a variable `animal` that holds the string `"zebra"`

`animal = "zebra"`

1. How would you print the string `"zebra"` using the variable that you created above?

`print animal`

1. What is interpolation? Use interpolation to print a sentence using the variable `animal`.

Interpolation is putting a string inside another string.

`print "My favorite animal is #{animal}."`

1. How do we get input from a user? What is the method that we would use?

We use the method `gets`, which means get string. We also use the method chomp to get rid of the line break that occurs when the user hits enter. We also store the input in a variable. For example:

```ruby
input = gets.chomp
```

1. Name and describe two common string methods.

`.chars` creates an array out of a string where each character is an element.
`.length` returns the number of characters in a string. 
