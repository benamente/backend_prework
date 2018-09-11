


require_relative "Trackers/Trackers.rb"
require_relative "DataObjects/DataObjects"
require_relative "../structs/Equivalency.rb"
require_relative "../structs/Probability.rb"
require_relative "../modules/GuessEval.rb"




class Guess

  include GuessEval

  Equivalency = Struct.new(:word_or_letter, :crypt_text, :solution)

  attr_accessor :goodness, :badness, :eq, :attempts, :tracker, :name, :adjusted_goodness, :cryp_text, :solution
  @@all_guesses = []
  def initialize(word_or_letter, cryp_text, solution, goodness)
    @eq = Equivalency.new(word_or_letter, cryp_text, solution)
    @cryp_text = cryp_text
    @attempts = 0
    @solution = solution
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


  module GuessEval

    def self.best_guess(arr_of_guesses = g_t.all.values)

      good_guess = arr_of_guesses.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
    end




    def self.goodness_by_freq(arr_of_strings)
      arr_of_freq = arr_of_strings.map {|s| s.freq}
      freq_sum = arr_of_freq.inject{ |sum, n| sum + n }
      arr_of_goodness = arr_of_freq.map {|num| 100 * num/freq_sum}
    end


  end








end
