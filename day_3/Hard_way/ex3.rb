def get_choice
  print "> "
  #I was able to figure out why someone might use STDIN, but didn't figure out why you'd use a global variable
  STDIN.gets.chomp
end



puts "You enter a dark room with two doors.  Do you go through door #1 or door #2?"

door = get_choice

if door == "1"
  puts "There's a giant bear here eating a cheese cake.  What do you do?"
  puts "1. Take the cake."
  puts "2. Scream at the bear."

  bear = get_choice

  if bear == "1"
    puts "The bear eats your face off.  Good job!"
  elsif bear == "2"
    puts "The bear eats your legs off.  Good job!"
  else
    puts "Well, doing %s is probably better.  Bear runs away." % bear
    puts "\nHowever, the cake seems threatened. 'That was my friend,' says the cake. 'Now I have no friends... Will you be my friend?'"

    puts "1. Befriend the cake."
    puts "2. Walk away slowly."

    friend = get_choice

    case friend
    when '1'
      p "You become friends with the cake."
      p "Several years pass. Your other friends are telling you you need to eat the cake, but they don't understand. Years turn into decades. You are on your deathbed. Do you will all that you own in this world to your 14 step-children, or to the cake?"
      puts "1. Children. \n2. Cake."
      will = get_choice
      case will
      when '1'
        p "You did the right thing. After all, they are sentient."
      when '2'
        p "With the millions of dollars it inherits, the cake is able to leverage it's way to win a Supreme Court nomination."
      else
        p "Your indecision means your fortune is donated to the D.A.I.T. (Decider's Against Indecisive Thinking) foundation."
      end
    when '2'
      p "You return home. And the world grows just a little more lonely."
    else
      p "The cake sues you for infringing on its creativity."
    end
  end

elsif door == "2"
  puts "You stare into the endless abyss at Cthulhu's retina."
  puts "1. Blueberries."
  puts "2. Yellow jacket clothespins."
  puts "3. Understanding revolvers yelling melodies."

  print "> "
  insanity = get_choice
  if insanity == "1" || insanity == "2"
    puts "Your body survives powered by a mind of jello.  Good job!"
  else
    puts "The insanity rots your eyes into a pool of muck.  Good job!"
  end

else
  puts "You stumble around and fall on a knife and die.  Good job!"
end

puts "\nThe previous adventure ends, a new one begins. \n ... \n Press any key to continue..."
gets
puts "You are in your apartment trying to get through some coding school pre-work and your dog is barking at basically nothing. What do you do?
1. Tell her to stop barking and continue doing The Work.
2. Take a break from the computer and give her some attention. Maybe go outside, maybe throw a ball or something."

dog = get_choice
case dog
when "1"
  puts "You finish the pre-work fifteen minutes earlier than you would have otherwise. As for hurting your dog's feelings, seems there's no consequences for now. But years later when PETA militants take over the government, from beyond the grave, your dog psychically communicates her displeasure to the FBI, you are arrested and given 49 dog years to life."
when "2"
  puts "Way to go life balance. Plus this pre-work isn't due for quite a while anyway."
else
  puts "Wow. You know, you're the first person to ever think of %s." % dog

end
