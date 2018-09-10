module GuessEval

  def self.best_guess(arr_of_guesses)
    good_guess = arr_of_guesses.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
  end



  module FindGood
    def self.from_list_by_freq_rough(num_poss, index)
      goodness = (100 / (num_poss ** 2)) + (100 - (index + 1) * (100 / num_poss))
    end


    def self.goodness(num_poss)
    end
    def self.from_list_by_freq
      arr = (1..num_poss).to_a

      new_arr = []
      num_poss = arr.length

      sum = 0

      arr.each_with_index do |poss, index|
        sum += from_list_by_freq_rough(num_poss, index)
      end
      arr.each_with_index do |poss, index|
        goodness = 100 * from_list_by_freq_rough(num_poss, index) / sum
        new_arr << goodness
      end
      return new_arr
    end
  end
end
