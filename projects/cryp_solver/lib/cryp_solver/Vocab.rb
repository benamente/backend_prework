require_relative "custom_array_methods.rb"
require_relative "custom_string_methods.rb"
require_relative "XWordSearch.rb"

module Vocab

  def self.set_up_dict_array(file_with_one_column)
    arr = File.readlines(file_with_one_column, "r").join.split("\n")
    arr.delete("")
    return arr
  end

  def self.set_up_dict_hash(file_with_two_columns)
    arr = set_up_dict_array(file_with_two_columns)
    arr.map! do |x|
      x.split("\t")
    end
    dictionary = arr.to_h
  end


  DICTIONARY = self.set_up_dict_hash("./lib/word_lists/words_by_freq_with_pos.txt")
  NOUNS = DICTIONARY.select {|k,v| v == 'n'}.keys
  CONTRACTIONS = self.set_up_dict_array("./lib/word_lists/contractions.txt")
  WORDS_WITH_REPEATING_LETTERS = DICTIONARY.keys.get_words_with_repeats


  def self.get_replist(array)
      return array.get_words_with_repeats.map{|x| x.include?("'") || x.include?("-") ? nil : x }.compact
  end

  def self.get_possible_wordlist_from_x_word(x_word, *solved_letters)
    #Deals with words with apostrophes be they contractions or...
    #puts "\n\n\nHERE\n\n\n" if x_word = "AiAX'X"

    if x_word.include?("'")
      poss = XWordSearch.match_possible_words(x_word, Vocab::CONTRACTIONS, *solved_letters)
      #...possessive nouns
      if /'[s]$/ =~ x_word || /'[X]$/ =~ x_word && !solved_letters.include?('s')
        potential_possesive_nouns = XWordSearch.match_possible_words(x_word[0..-3], Vocab::NOUNS, *solved_letters)
        potential_possesive_nouns.map! {|n| n + "'s"}
        poss.concat(potential_possesive_nouns)
      end

    else
      poss = XWordSearch.match_possible_words(x_word, Vocab::DICTIONARY.keys, *solved_letters)

    end
    if poss


      if poss.length == 0
        wordlist = "NONE FOUND"
      elsif poss.length <= 75
        wordlist = poss
      else
        p poss
        wordlist = "MANY"
      end
    end
  end





end
