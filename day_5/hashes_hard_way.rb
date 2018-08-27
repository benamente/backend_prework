

require ("pp")

states = {
  :Oregon => 'OR',
  :Florida => 'FL',
  :California => 'CA',
  'New York' => 'NY',
  :Michigan => 'MI'
}

cities =  {
  :CA => 'San Francisco',
  :MI => 'Detroit',
  :FL => 'Jacksonville'
}

cities[:NY] = 'New York'
cities[:OR] = 'Portland'

puts '-' * 10
puts "NY State has: #{cities['NY']}"
puts "OR State has: #{cities['OR']}"

puts '-' * 10
puts "Michigan's abbreviation is: #{states['Michigan']}"
puts "Florida's abbreviation is: #{states['Florida']}"


puts '-' * 10
#Glad to learn each can iterate like that, with two values. Can it do the same for a nested array?
states.each do |state, abbrev|
  puts "#{state} is abbreviated #{abbrev}"
end

puts '-' * 10
states.each do |state, abbrev|
  city = cities[abbrev.to_sym]
  puts "#{state} is abbreviated #{abbrev} and has city #{city}"
end


#changed the keys to symbols wondering if that would break anything, and it didt!
#Don't see an easy way around leaving New York as a string though



puts '-' * 10
# nil case
state = states['Texas']

# if !variable syntax is useful here, would like to get more comfortable using it.
if !state
  puts "Sorry, no Texas."
end

city = cities['TX']
city ||= 'Does Not Exist'
puts "The city for the state of 'TX is: #{city}'"

provinces = {
  :Ontario => 'ON',
  :Quebec => 'QC',
  'Nova Scotia' => 'NS',
  'New Brunswick' => 'NB',
  :Manitoba => 'MB',
  'British Colombia' => 'BC',
  'Prince Edward Island' => 'PE',
  :Saskatchewan => 'SK',
  :Alberta => 'AB',
  'Newfoundland and Labrador' => 'NL'
}

capitals = {
  ON: 'Toronto',
  QC: 'Quebec City',
  NS: 'Halifax',
  NB: 'Fredericton',
  MB: 'Winnipeg',
  BC: 'Victoria',
  PE: 'Charlottetown',
  SK: 'Regina',
  AB: 'Edmonton',
  NL: 'St. John\s'
}

puts '-' * 10

provinces.each do | province, abbrev|
  puts "The capital of #{province} (#{abbrev}) is #{capitals[abbrev.to_sym]}"
end


#I was confused by this bit of code I found in hash documentation:...
reviews = {}

reviews['book1'] = 'Great reference!'
reviews['book2'] = 'Nice and compact!'

puts reviews.length #=> 1
#...Why should it result in 1? Aren't there two key value pairs?
#in the original, book1 were Book objects. I suppose that might make the difference,
#but I don't see how. A typo in Ruby documentation seems unlikely.
#tried using irb to worki this out, ran into some difficulty.
#going to create a new .rb to try to puzzle this out... (See puzzling_out_reviews.rb)


start = Time.now


#Writing hash for cryptogram solver
arr = ('a'..'z').to_a.map {|x| [x.to_sym, '???']}
alphatracker = Hash[arr]

puts Time.now - start

pp alphatracker #Observation, this line of code takes 10x or more computing time than making the hash...

#found a way of making hashes in ruby docs I was unfamiliar with. Decided to
#use it to store info about employees.
h = Hash.new { |hash, key| hash[key] = "Player #{key}"}
h[1] #works with either a string or an integer.
pp h # => {"1"=>"Player 1"}
#seems to wok as expected, now trying to add many players at once.
#h[1,2] nope
#h[[1,2]] nope
#h[*[1,2]] nope
#Through googling found hash.values_at and it did what I wanted it to:
h.values_at(*(1..20).to_a)
pp h

#As for study drill 3, I'm assuming anything that would need an index can't be
#done with hashes. For example, there's no .index(). There's .each, but no
#.each_with_index. There's a delete, and delete_if, but there's no delete_at
#there's flatten, but it returns an array and not a hash. There's no .map or
#.collect.  There's no push or pop or shuffle or slice or sort. There is a shift.
# Curious how you would change every value or key in a hash without map.
