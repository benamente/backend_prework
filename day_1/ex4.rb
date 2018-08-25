#setting the number of cars to 100
cars = 100
#setting the space per car to 4.0
space_in_a_car = 4.0
#setting the number of drivers to 30
drivers = 30
#setting the number of passengers to 90
passengers = 90
#setting the number of cars not driven to be calculated by subtracting the number of cars by the the number of drivers.
cars_not_driven = cars - drivers
cars_driven = drivers
#calculating carpool capacity
carpool_capacity = cars_driven * space_in_a_car
#calculating average passengers per cars
average_passengers_per_car = passengers / cars_driven

puts "There are #{cars} cars available."
puts "There are only #{drivers} drivers available."
puts "There will be #{cars_not_driven} empty cars today."
puts "We can transport #{carpool_capacity} people today."
puts "We have #{passengers} people to carpool today."
puts "We need to put about #{average_passengers_per_car} in each car."

#Study drill: If the computer didn't recognize carpool_capacity he probably
#made a typo when he defined it
