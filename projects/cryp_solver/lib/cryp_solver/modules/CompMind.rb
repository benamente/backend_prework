require_relative "GuessEval"
require_relative "../classes/Guess.rb"


module MakeGuess
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

  private

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
        goodness_arr = GuessEval.goodness(num_poss)
        word.likely_solutions.each_with_index do |x, index|
          guesses << Guess.new(Equivalency.new(word.cryp_text, x), goodness_arr[index])
        end
      end
    end
    return guesses
  end

  def letter_guesses(wt, at)
  end

end
