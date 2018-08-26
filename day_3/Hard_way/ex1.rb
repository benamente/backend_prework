people = 11
cats = 30
dogs = 10


if people < cats
  puts "Too many cats! The world is doomed!"
end

if people > cats
  puts "Not many cats! The world is saved!"
end

if people < dogs
  puts "The world is drooled on!"
end

if people > dogs
  puts "The world is dry!"
end


dogs += 5

if people >= dogs
  puts "People are greater than or equal to dogs."
end

if people <= dogs
  puts "People are less than or equal to dogs."
end


if people != dogs || people == 20
  puts "People are dogs."
end


if people == dogs
  puts "People are dogs."
end
=begin
What do you think the if does to the code under it?
It evaluates a condition and executes code if the condition is true.

Why does the code under the if need to be indented two spaces?
To distinguish this block of code from its surroundings.

What happens if it isn't indented?
Potential for confusion. Other than that, it works the same.

Can you put other boolean expressions from Exercise 27 in the if-statement? Try it.
Yes. Okay.

What happens if you change the initial values for people, cats, and dogs?
Then that's how they're evaluated.

=end
