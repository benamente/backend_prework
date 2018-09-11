require_rel "../classes"

require "pry"

module GuessEval

  def self.best_guess(arr_of_guesses = g_t.all.values)
    good_guess = arr_of_guesses.return_objects_with(:attempts, 0).max_attribute(:adjusted_goodness)
  end




    def self.goodness_by_freq(arr_of_strings)
      arr_of_freq = arr_of_strings.map {|s| s.freq}
      freq_sum = arr_of_freq.inject{ |sum, n| sum + n }
      arr_of_goodness = arr_of_freq.map {|num| 100 * num/freq_sum}
    end

    # def self.from_list_by_freq_rough(num_poss)
    #   arr = (1..num_poss).to_a
    #
    #   new_arr = []
    #   num_poss = arr.length
    #
    #   sum = 0
    #
    #   arr.each_with_index do |poss, index|
    #     sum += from_list_by_freq_roughest(num_poss, index)
    #   end
    #   arr.each_with_index do |poss, index|
    #     goodness = 100 * from_list_by_freq_roughest(num_poss, index) / sum
    #     new_arr << goodness
    #   end
    #   return new_arr
    # end

end
