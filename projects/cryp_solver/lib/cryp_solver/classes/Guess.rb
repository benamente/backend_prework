


require_relative "Trackers/Trackers.rb"
require_relative "DataObjects/DataObjects"
require_relative "../structs/Equivalency.rb"
require_relative "../structs/Probability.rb"
require_relative "../modules/GuessEval.rb"




class Guess

  include GuessEval

  Equivalency = Struct.new(:word_or_letter, :crypt_text, :solution)

  attr_accessor :goodness, :badness, :eq, :attempts, :tracker, :name, :adjusted_goodness, :cryp_text
  @@all_guesses = []
  def initialize(word_or_letter, cryp_text, solution, goodness)
    @eq = Equivalency.new(word_or_letter, cryp_text, solution)
    @cryp_text = cryp_text
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
