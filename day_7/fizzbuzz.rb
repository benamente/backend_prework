




def print_fizzbuzz (lower = 1, upper = 100)
  for i in (lower..upper) do
    if i % 3 == 0 && i % 5 == 0
      puts "FizzBuzz"
    elsif i % 3 == 0
      puts "Fizz"
    elsif i % 5 == 0
      puts "Buzz"
    else
      puts "#{i.to_s}"
    end
  end
end


print_fizzbuzz


print_fizzbuzz(30000, 30100)
