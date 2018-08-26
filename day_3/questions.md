## Day 3 Questions

1. What is a conditional statement? Give three examples.  

A conditional statement is one that ruby (or any language) evaluates to `true` or `false`.
It often includes comparison operators ( `>`, `<`, `<=`, `>=`, `==`, `!=`), for example:
`the_sun > the_earth` => `true`
It can also include syntax such as `&&` (and: both statements must be true to return true) or `||` (or: only one statement must be true to return true):
`the_sun > the_earth && the_sun < the_earth` => `false`
It can also include a method that evaluates to `true` or `false`. For example:
`conditional_statement_options.include?(methods_with_question_marks_at_the_end)`  

1. Why might you want to use an if-statement?  

To execute code only under certain conditions.  

1. What is the Ruby syntax for an if statement?  
```ruby
if condition == true
  do_something #How do we add space to the left of text in markdown?
end
```
also, for simpler situations:
```ruby
if condition == true then do_something;
```
even fewer tokens:
```ruby
do_something if condition == true;
```

1. How do you add multiple conditions to an if statement?  

That depends. If you wanted to evaluate multiple conditions before doing anything, you could use `&&` or `||`. If you wanted to evaluate a secondary condition if the first one turns up false, you'd use `elsif.`

1. What is the Ruby syntax for an if/elsif/else statement?
```ruby
if condition == true
  do_something
elsif other_condition == true
  do_something_else
#... add as many elsif statements as you'd like
else
  #no conditions were true so...
  do_this_other_thing
end
```

1. Other than an if-statement, can you think of any other ways we might want to use a conditional statement?
A while loop.
`conditional_statement? do_if_true : do_if_false` syntax (which is kind of just a truncated if statement though...)
