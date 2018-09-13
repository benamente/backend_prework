

module GuessEval

  def best_guess(arr_of_guesses = self.all.values)
    best_score = arr_of_guesses.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
    arr_of_guesses.return_object_with(:adjusted_goodness, best_score)
  end




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
