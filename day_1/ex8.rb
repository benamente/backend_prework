require ("pp")

class String
#as written items in selection should contain distinct first letters
  def validate(selection, re_ask = "Invalid entry")
    validated = self
    selection.each do |x|
      if self.downcase == x[0]
        validated = x
      end
    end
    if selection.include?(validated)
      return validated
    else
      puts re_ask
      gets.chomp.validate(selection, re_ask)
    end
  end
end

def stat_in(stat, pre_q = "What is your ", post_q = "? ")
  puts pre_q + stat + post_q
  gets.chomp
end

def stats_in(stats, query = "Would you like to correct your ")
  print query
  stats.each_with_index do |stat, i|
    print stat[0];
    print ", " if i != stats.count - 1;
    print "or " if i == stats.count - 2;
    print "? " if i == stats.count - 1;
  end
  stats_names = stats.map { |x| x[0] }
  stat = gets.chomp.validate(stats_names)
  stats.assoc(stat)[1] = stat_in(stat, "Please enter your ", ". ")
  return stats
end

def confirm(stats)
  stats.each_with_index do |x, i|
    print "So " if i == 0; print "your #{x[0]} is #{x[1]}";
    print ", " if i != stats.count - 1;
    print "and " if i == stats.count - 2;
    print ". " if i == stats.count - 1;
  end
  print "Is that correct? (Please enter yes or no). "
  y_n = gets.chomp.validate(["yes","no"], "Please enter yes or no. ")
  puts "Thank you for confirming!" if y_n == 'yes';
  if y_n == 'no'
    confirm(stats_in(stats))
  end
end




arr = ["name", "age", "height"].map {|x| [x]}
arr.map do |x|
  x << stat_in(x[0])
end
arr = confirm(arr)


=begin
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
=end
