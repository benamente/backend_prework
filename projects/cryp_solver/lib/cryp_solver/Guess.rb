


require_relative "Tabs.rb"
require_relative "WordData.rb"
require_relative "Equivalency.rb"
require_relative "Deduction.rb"



class Guess
  attr_accessor :goodness, :badness, :eq, :already_failed, :tabs, :name, :adjusted_goodness
  @@all_guesses = []
  def initialize(equilvancy_to_try, goodness)
    if @@all_guesses.list_attribute(:eq).include?(equilvancy_to_try)
      @already_failed = true
    else
      @already_failed = false
      @eq = equilvancy_to_try
      @goodness = goodness
      @badness = 0
      @adjusted_goodness = goodness - badness
      @@all_guesses << self
      @name = equilvancy_to_try.val.to_s
    end
  end
end

module Math
  def self.rough_goodness(num_poss, index)
    n = (100 / (num_poss ** 2)) + (100 - (index + 1) * (100 / num_poss))
  end


  def self.calc_goodness(num_poss)
    arr = (1..num_poss).to_a

    new_arr = []
    num_poss = arr.length

    sum = 0

    arr.each_with_index do |poss, index|
      sum += rough_goodness(num_poss, index)
    end
    arr.each_with_index do |poss, index|
      goodness = 100 * rough_goodness(num_poss, index) / sum
      new_arr << goodness
    end
    return new_arr
  end
end

def best_guess(arr_of_guesses)
  good_guess = arr_of_guesses.return_objects_with(:already_failed, false).max_attribute(:adjusted_goodness)
end

def suggest_guesses(tabs)
  a = letter_guesses(tabs.alpha_tracker)
  b = word_guesses(tabs.word_tracker)
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
      goodness_arr = Math.calc_goodness(num_poss)
      word.likely_solutions.each_with_index do |x, index|
        guesses << Guess.new(Equivalency.new(:solution, x), goodness_arr[index])
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
