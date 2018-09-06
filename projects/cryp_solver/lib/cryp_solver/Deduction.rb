
module Deduction
  def find_all_must_letters(wt)

  end
  def self.find_must_letters(list_of_strings, indeces_of_unsolved)
    arr = []
    indeces_of_unsolved.each do |i|
      add = true
      letter = nil
      list_of_strings.each do |str|
        if letter && letter != str[i]
          add = false
          next
        end
        letter = str[i]
      end
      if add == false
        next
      else
        arr << [i, list_of_strings[0][i]]
      end
    end
    return arr
  end
end
