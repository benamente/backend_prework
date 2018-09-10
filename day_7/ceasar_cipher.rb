require_relative "../projects/cryp_solver/lib/cryp_solver/modules/Vocab.rb"
require_relative "../projects/cryp_solver/lib/cryp_solver/modules/WordSearch.rb"


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



def make_ciph
  puts "Enter message:"
  message = gets.chomp.downcase
  puts "Enter shift amount"
  shift_amount = gets.chomp.to_i
  alphabet = ('a'..'z').to_a
  code_alphabet = alphabet.rotate(shift_amount)
  alpha_hash = alphabet.zip(code_alphabet).to_h
  cipher = []
  message.chars.each do |char|
    if alphabet.include?(char)
      cipher << alpha_hash[char].upcase
    else
      cipher << char
    end
  end

  puts "Cipher:"
  puts cipher.join
end

def find_max(array)
  max = 0
  array.each do |x|
    if x > max
      max = x
    end
  end
  return max
end


def solve_ciph
  puts "Enter coded message:"

  ciphered_text = gets.chomp.downcase
  alphabet = ('a'..'z').to_a
  solutions = {}
  puts "Trying all 26 possibilities."
  for i in (1..26) do
    p i
    code_alphabet = alphabet.rotate(i)
    alpha_hash = alphabet.zip(code_alphabet).to_h
    solution = []
    ciphered_text.chars.each do |char|
      if alphabet.include?(char)
        solution << alpha_hash[char].upcase
      else
        solution << char
      end
    end
    words = solution.join.split(" ")
    score = 0
    words.each do |word|
      score += WordSearch.word_likelihood(word.downcase)
    end
    solutions[score] = solution.join
  end

  best_score = find_max(solutions.keys)

  puts "Solution:"

  puts solutions[best_score]



end



puts "Would you like to -make- a ceasar cipher or -solve- one?"

choice = gets.chomp.validate(['make', 'solve'])

if choice == 'make'
  make_ciph
elsif choice == 'solve'
  solve_ciph
end
