# Setting the types of people to one zero.
types_of_people = 10
#Setting string x.
x = "There are #{types_of_people} types of people."
#Setting a rather redundant variable.
binary = "binary"
#Setting a slightly less redundant variable.
do_not = "don't"
#Setting string string y. It contains our redundant variables.
y = "those who know #{binary} and those who #{do_not}."

#Printing our first string.
puts x
#Printing the next string.
puts y

#Printing the same but inside another string.
puts "I said: #{x}."
puts "I also said: '#{y}'."

#Setting up for failure.
hilarious = false
#Accepting the truth.
joke_evaluation = "Isn't that joke so funny?! #{hilarious}"

#Revealing the truth.
puts joke_evaluation

#Setting up two variables...
w = "This is the left side of..."
e = 'a string with a right side.'

#... and then printing them side by side.
puts w + e

# Study drill 2,3: There are only 4 places where a string is put inside another
# string. There are other uses of #{}, but only to place numbers or booleans.
# SD4: adding strings with + concats them. A longer string results because
# things always get bigger when adding things to them, unless you're dealing
# with negative numbers. And strings are always strings, never negative
# numbers.
# SD5: Strings with sigle-quotes still work unless the string includes a
# variable that's "hashed in" with #{}. It's because double quotes allow
# characters that single quotes don't.
