


require_relative "Trackers/Trackers.rb"
require_relative "DataObjects/DataObjects"
require_relative "../structs/Equivalency.rb"
require_relative "../structs/Probability.rb"
require_relative "../modules/GuessEval.rb"




class Guess

  Equivalency = Struct.new(:word_or_letter, :crypt_text, :solution)

  attr_accessor :goodness, :badness, :eq, :attempts, :tracker, :name, :adjusted_goodness
  @@all_guesses = []
  def initialize(word_or_letter, cryp_text, solution, goodness)
    @eq = Equivalency.new(word_or_letter, cryp_text, solution)
    @attempts = 0
    if @@all_guesses.list_attribute(:eq).include?(@eq)
      @attempts += 1
    else
      @goodness = goodness
      @badness = 0
      @adjusted_goodness = goodness - badness
      @@all_guesses << self
      @name = eq.solution.to_s
    end
  end
end

def self.best_guess(arr_of_guesses)
  good_guess = arr_of_guesses.return_objects_with(:already_failed, false).max_attribute(:adjusted_goodness)
end



def self.suggest_guesses(tracker)
  a = letter_guesses(tracker.letter_tracker)
  b = word_guesses(tracker.word_tracker)
  if !a
    return b
  elsif !b
    return a
  else
    return a + b
  end
end

def word_guesses(wt)
  guesses = []
  wt.each do |word|
    if word.solution
      next
    elsif word.likely_solutions
      num_poss = word.likely_solutions.length
    else
      num_poss = 0
    end
    if num_poss < 6 && num_poss > 0
      goodness_arr = GoodMath.calc_goodness(num_poss)
      word.likely_solutions.each_with_index do |x, index|
        guesses << Guess.new(Equivalency.new(word.cryp_text, x), goodness_arr[index])
      end
    end
  end
  return guesses
end

def letter_guesses(wt, at)
end

module Evaluate
  def find_goodness
  end
end
