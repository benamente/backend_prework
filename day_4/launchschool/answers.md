2. What do the following expressions evaluate to?

1. x = 2
2
2. puts x = 2
"2" printed in the terminal
3. p name = "Joe"
"Joe" printed in the terminal. (Good to know that while print and puts return nil, p returns a string)
4. four = "four"
"four"
5. print something = "nothing"
nil  


4. What will the following code print to the screen?

```ruby
def scream(words)
  words = words + "!!!!"
  return
  puts words
end

scream("Yippeee")
```
Answer:
It will print nothing because the scream method returns before it reaches `puts words`  

6. What does the following error message tell you?

ArgumentError: wrong number of arguments (1 for 2)
  from (irb):1:in \`calculate_product'
  from (irb):4
  from /Users/username/.rvm/rubies/ruby-2.0.0-p353/bin/irb:12:in \`<main>'

Answer:  Calculate product needs 2 arguments. In line 4 (or maybe 12), you only passed in 1.
