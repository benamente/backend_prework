

  module GuessEval

    def best_guess(arr_of_guesses = self.all.values)
      best_score = arr_of_guesses.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
      arr_of_guesses.return_object_with(:adjusted_goodness, best_score)
    end




    def self.goodness_by_freq(arr_of_strings)
      arr_of_freq = arr_of_strings.map {|s| s.freq}
      freq_sum = arr_of_freq.inject{ |sum, n| sum + n }
      arr_of_goodness = arr_of_freq.map {|num| 100 * num/freq_sum}
    end


  end
