

module GuessEval

  def best_guess(arr_of_guesses = self.all.values)
    arr_of_guesses.return_object_with(:adjusted_goodness, best_score(arr_of_guesses))
  end

  def best_guess_plus(arr_of_guesses = self.all.values, options = {})
    bg = best_guess(arr_of_guesses)
    nbg = next_best_guess(arr_of_guesses)
    closeness = best_score(arr_of_guesses) - next_best_score(arr_of_guesses)
    return {best_guess: bg, closeness: closeness, next_best_guess: nbg}
  end

  private
  def next_best_score(a_of_g)
    best_score(a_of_g - best_guess(a_of_g))
  end

  def next_best_guess(a_of_g)
    best_guess(a_of_g - best_guess(a_of_g))
  end

  def best_score(a_of_g)
    best_score = a_of_g.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
  end
  public



  def self.goodness_by_freq(arr_of_strings, options = {})
    word_or_name = options[:word_or_name] || :word
    arr_of_freq = arr_of_strings.map {|s| s.freq(word_or_name: word_or_name)}
    freq_sum = arr_of_freq.inject{ |sum, n| sum + n }

    if freq_sum == 0
      return [0] * arr_of_strings.length
    end
    arr_of_goodness = arr_of_freq.map {|num| 100 * num/freq_sum}
    # binding.pry if arr_of_strings.include?("fears")
    return arr_of_goodness
  end


end
