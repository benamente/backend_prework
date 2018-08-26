#Defining the method Cheese and Crackers which prints the cracker count and box
#count passed into it, along with two other lines of text.
def cheese_and_crackers(cheese_count, boxes_of_crackers)
  puts "You have #{cheese_count} cheeses!"
  puts "You have #{boxes_of_crackers} boxes of crackers!"
  puts "Man that's enough for a party!"
  puts "Get a blanket.\n"
end


# puts "We can just give the function numbers directly:"
# #runs cheese_and_crackers with 20 cheese and 30 boxes.
# cheese_and_crackers(20, 30)
#
#
# puts "OR, we can use variables from our script:"
# #Gives integer values to two variables...
# amount_of_cheese = 10
# amount_of_crackers = 50
# #... and then passes them into the method.
# cheese_and_crackers(amount_of_cheese, amount_of_crackers)
#
# #passes 30 cheese and 11 crackers into the method, but getting to those values
# #by doing math inside the method call.
# puts "We can even do math inside too:"
# cheese_and_crackers(10 + 20, 5 + 6)
#
# #Each argument here comes as the result of adding a pre-assigned variable to a
# #number.
# puts "And we can combine the two, variables and math:"
# cheese_and_crackers(amount_of_cheese + 100, amount_of_crackers + 1000)

#my own method
#Each mouse squeaks to every other mouse at the party. The more mice, the more squeaks.
def mouse_party(mouse_count)
  count = mouse_count
  squeaks = 1
  while count > 1 do
    squeaks += count
    count -= 1
  end
  squeaks.times {print "squeak! "}
  puts "\n#{mouse_count} mice had a party. There were a total of #{squeaks} squeaks."
end

arr = (1..10).to_a

arr.each {|n| mouse_party(n)}
