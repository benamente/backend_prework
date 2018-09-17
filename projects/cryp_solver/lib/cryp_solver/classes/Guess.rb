


require_relative "Trackers/Trackers.rb"
require_relative "DataObjects/DataObjects"
require_relative "../structs/Equivalency.rb"
require_relative "../structs/Probability.rb"
require_relative "../modules/GuessEval.rb"




class Guess

  include GuessEval
  include Comparable

  Equivalency = Struct.new(:word_or_letter, :cryp_text, :solution)

  attr_accessor :goodness, :badness, :eq, :attempts, :tracker, :name,
                :cryp_text, :solution, :round,
                :bonuses, :word_or_letter, :parent, :depth

  @@all_guesses = []
  def initialize(word_or_letter, cryp_text, solution, goodness, round)
    @word_or_letter = word_or_letter
    @round = round
    @eq = Equivalency.new(word_or_letter, cryp_text, solution)
    @cryp_text = cryp_text
    @attempts = 0
    @solution = solution
    # if @@all_guesses.list_attribute(:eq).include?(@eq)
    # #   @attempts += 1
    # else
    @goodness = goodness
    @badness = 0
    @@all_guesses << self
    @name = eq.solution.to_s
    @bonuses = {}
    @depth = 0
    # end
  end
  #
  def <=>(other)
    unless other.is_a? Guess
      return nil
    end
    if self.cryp_text == other.cryp_text
      if self.solution == other.solution
        return 0
      end
    end
    if self.adjusted_goodness > other.adjusted_goodness
      return 1
    else
      return -1
    end

  end

  def eql?(other)
    if (self <=> other) == 0
      return true
    else
      return false
    end
  end
  # alias :==

  def adjusted_goodness
    @goodness - @badness + @bonuses.values.inject(0, :+)
  end

end
