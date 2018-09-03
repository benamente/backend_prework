require_relative "custom_array_methods.rb"
require_relative "custom_string_methods.rb"
require_relative "Guess.rb"



module XWordSearch

  #given a string such as "hXlX" will return an array of all possible words, X's representing any character

  def self.match_possible_words(x_string, arr_of_words, *solved_letters)

    possible_words = arr_of_words.select{|word| x_string.length == word.length}
    possible_words.map! { |x| x.downcase }
  #first handling simplest possible case... XXXXX, for example
    unless x_string.has_chars_besides?("X")
      return possible_words.remove_all_with(solved_letters).reject{|x| x.has_repeater_chars?}
    end
  #now cases where there are solved_letters (but no repeaters...)
  unsolved_repeaters = x_string.chars.reject{|char| char.is_lower? || char == "X"}
  if unsolved_repeaters.length == 0
    return match_possible_with_solved_letters(x_string, possible_words, *solved_letters)
  else

  #now cases where there are repeating characters
    return match_possible_repeaters(x_string, possible_words, *solved_letters)
  end


  end

#retuns words where the solved letters are present and in the right places
  def self.match_possible_with_solved_letters(x_string, possible_words, *solved_letters)
    x_string_solved_letters = x_string.chars.reject{|char| char.is_upper?}.uniq
    wordlist_narrowed = []
    possible_words.each do |word|
      if word.length != x_string.length then next end
      if word.include?("'")
          next unless x_string.include?("'")
          unless x_string_solved_letters.include?("'")
            x_string_solved_letters << "'"
          end
          #pp x_string_solved_letters.remove_all_without("'", x.index("'"))
      end
      #if x_string_solved_letters == []; return [] end
      add = true
      x_string_solved_letters.each do |letter|
          unless word.get_indices_of_letter(letter) == x_string.get_indices_of_letter(letter)
            add = false
          end
      end
      if add == true
          wordlist_narrowed << word
      end
    end
    unless x_string.has_repeater_chars?("X")
      wordlist_narrowed.reject!{|x| x.has_repeater_chars?(*x_string_solved_letters)}
    end
    wordlist_narrowed.remove_all_with(solved_letters - x_string_solved_letters)
  end

  def self.match_possible_repeaters(x_string, possible_words, *solved_letters)
    wordlist_narrowed = possible_words.reject{|word| word.get_repeater_chars == []}
    x_string_indices = x_string.get_indices_of_repeaters('X')
    list = []
    possible_words.each do |y|
        if x_string_indices ==  y.get_indices_of_repeaters
            list << y
        end
        # if list.length > 15
        #    return list.length.to_s
        # end
    end
    if x_string.chars.reject{|char| char.is_upper?}.length == 0
      return list.remove_all_with(*solved_letters)
    else
      return match_possible_with_solved_letters(x_string, list, *solved_letters)
    end
  end


end
