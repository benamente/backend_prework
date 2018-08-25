def in_age
  puts "How old are you?"
  age = gets.chomp
end
def in_height
  puts "How tall are you?"
  height = gets.chomp
end
def in_weight
  puts "How much do you weigh?"
  weight = gets.chomp
end

def clear_it_up(age, height, weight)
  puts "Glad to get that clear. Just to be 100% certain tho..."
  ask_until_confirmed(age, height, weight)
end

def ask_until_confirmed(age, height, weight)
  puts "So you're #{age} old, #{height} tall, and #{weight} heavy? y/n"
  confirmation = gets.chomp.downcase
  if confirmation == 'y'
    puts "Thank you for confirming."
  elsif confirmation == 'n'
    puts "Okay. Which did we get wrong? Age (a), height (h), or weight (w)?"
    correction = gets.chomp
    if correction == 'a'; age = in_age; clear_it_up(age, height, weight) end
    if correction == 'h'; height = in_height; clear_it_up(age, height, weight) end
    if correction == 'w'; weight = in_weight; clear_it_up(age, height, weight)
    else puts "Invalid entry."
      ask_until_confirmed(age, height, weight)
    end
  else
    puts "Invalid entry."
    ask_until_confirmed(age, height, weight)
  end
  return [age, height, weight]
end



  age = in_age
  height = in_height
  weight = in_weight

  age, height, weight = ask_until_confirmed(age, height, weight)







print "How smart are you? "
iq = gets.chomp
print "How normal are you? "
norm = gets.chomp
print "How much do you care? "
investment = gets.chomp

puts "Wow. You're #{iq} intelligent, #{norm} normal and you care #{investment}."
