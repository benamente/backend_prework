
def num_to_word(integer)
  hash = {
    10**15 => "quadrillion",
    10**12 => "trillion",
    10**9 => "billion",
    1000000 => "million",
    1000 => "thousand",
    100 => "hundred",
    90 => "ninety",
    80 => "eight",
    70 => "seventy",
    60 => "sixty",
    50 => "fifty",
    40 => "forty",
    30 => "thirty",
    20 => "twenty",
    19 => "nineteen",
    18 => "eighteen",
    17 => "seventeen",
    16 => "sixteen",
    15 => "fifteen",
    14 => "fourteen",
    13 => "thirteen",
    12 => "twelve",
    11 => "eleven",
    10 => "ten",
    9 => "nine",
    8 => "eight",
    7 => "seven",
    6 => "six",
    5 => "five",
    4 => "four",
    3 => "three",
    2 => "two",
    1 => "one"
  }
  string = String.new
  if integer >= 10**18
     string += integer.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse #found this online. uses regular expressions. a a bit aov
#Breaking down gsub(/(\d{3})(?=\d)/, '\\1,').
#I know /(\d{3}) finds three digits in a row. I don't know what (?=\d) means.
# I looked it up and ?= is a look ahead. it's saying that the three digits in a row
# need to be followed by another digit. Without this I presume it would print
# a comma at the end of every number. (A test in irb does not exactly bear this out
# but I was on the right track. Since it reverses, without the lookahead it sometimes
#prints a comma at the beginning of the number. one hundred => ,100)
# I still don't know what '\\1,' means. Looked it up and found out what \1 means.
#\1 refers to the first parenthetical in gsub's argument.  So in gsub((three_digs)(?=\d), \1) \1
# refers to three_digs. Maybe the second backslash has something to do with the parenthetical
# being inside the forward slashes indicating it's a regular expression?
# actually, I think it probably has more to do with it being inside a single
# quotes.
# I tried switching to double quotes in irb => "1,\x01,\x01,\x01"
# and when I switched it back to two slashes
# while keeping two quotes, it gave me 1,000,000,000, the expected result, again.
# plus '\\' irb => "\\".  So no longer thinking it's single quotes.
# Okay. On stack overflow, "\\1 becomes \1 when evaluated". So it doesn't have to do with
# quotes, but that wasn't too far off.
  elsif integer == 0
    return string
  elsif integer < 100
    if hash.keys.include?(integer)
      string += hash[integer]
      return string
    else
      string += hash[integer/10 * 10].to_s + "-" + hash[integer%10].to_s
    end
  elsif integer < 1000
    string += hash[integer/100].to_s + " hundred"
    if integer % 100 > 0
      string += " and #{num_to_word(integer%100)}"
    end
    return string
  else
    largest = 10**((integer.to_s.length - 1) / 3 * 3)
    string += "#{num_to_word(integer/largest)} #{hash[largest]}"
    remainder = integer % largest
    if remainder > 0
      if remainder >= 100
        string += " "
      elsif remainder > 0
        string += " and "
      end
      string += "#{num_to_word(remainder)}"
    end
    return string
  end

end


def verses (monkey_count = 10)
  loop do
    puts "#{num_to_word(monkey_count).capitalize} little monkeys jumping on the bed,"
    puts "One fell off and bumped his head,"
    monkey_count -= 1
    puts "Mama called the doctor and the doctor said,\n"
    if monkey_count > 0
      puts '"Get those monkeys right to bed!"'; puts "\n";
    else
      puts '"No more monkeys jumping on the bed!"'
      break
    end
  end
end

verses

sleep(1)
puts "\n And all seemed well."
sleep(1)
puts "But was it?..."
sleep(2)
puts "\t...the very next night as the sun fell..."
sleep(1)
puts "...how many monkeys were jumping on the bed?"
monkey_count = gets.chomp.to_i
verses(monkey_count)
