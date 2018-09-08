require_relative "Guess.rb"
require_relative "DataObjects.rb"

module Deduction
  def find_all_must_letters(wt)

  end

  def self.find_must_letters(word)
    indeces_of_unsolved = word.x_string.get_indices_of_uppers
    list_of_strings = word.likely_solutions
    indeces_of_unsolved.each do |i|
      add = true
      letter = nil
      list_of_strings.each do |str|
        if letter && letter != str[i]
          add = false
          next
        end
        letter = str[i]
      end
      if add == false
        next
      else
        arr << Guess.new(WordEq.new(word.cryp_text[i], letter), 90)
      end
    end
    return arr
  end

  #Make many consanants in a row smell fishy even for unknown words
end
