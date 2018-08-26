people = 300
cars = 1
trucks = 1.5


if cars > people
  puts "We should take the cars."
elsif cars < people
  puts "We should not take the cars."
else
  puts "We can't decide."
end

if trucks > cars
  puts "That's too many trucks."
elsif trucks < cars
  puts "Maybe we could take the trucks."
else
  puts "We still can't decide."
end

if people > trucks
  puts "Alright, let's just take the trucks."
else
  puts "Fine, let's stay home then."
end

if people > (cars + trucks) && people > 20
  puts "We have a population problem."
end

if cars + trucks < 20 && people - cars > 20
  puts "We lack sufficient transportation in this city."
  if people > 200
    puts "We should build a monorail."
  end
end

=begin
Try to guess what elsif and else are doing.
If the condition after `if` is false, then elsif's condition is checked, and so on until there are no more elsifs,
until the one is true and then its codeblock is executed.
If no conditions have returned true, that's when else's codeblock is executed.

Change the numbers of cars, people, and trucks, and then trace through each if-statement to see what will be printed.
I was unsurprised, to be honest.

Try some more complex boolean expressions like cars > people || trucks < cars.


Above each line write an English description of what the line does.
=end
