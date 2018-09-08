require_relative "custom_array_methods.rb"
require_relative "custom_string_methods.rb"
require_relative "XWordSearch.rb"
require "yaml"
module Vocab

  def self.set_up_dict_array(file_with_one_column)
    arr = File.readlines(file_with_one_column, "r").join.split("\n")
    arr.delete("")
    return arr
  end

  def self.set_up_dict_hash(file_with_two_columns)
    arr = set_up_dict_array(file_with_two_columns)
    arr.map! do |x|
      #x.split("\t")
      x.split(" ")
    end
    dictionary = arr.to_h
  end


  DICTIONARY = self.set_up_dict_hash("./lib/word_lists/words_by_freq_with_pos.txt")
  NOUNS = DICTIONARY.select {|k,v| v == 'n'}.keys
  PLURALS = YAML.load_file('./lib/word_lists/plurals.yml')
  VERBS = DICTIONARY.select {|k,v| v == 'v'}.keys
  VERB_FORMS_HASH = YAML.load_file('./lib/word_lists/verb_forms.yml')
  VERB_FORMS_ARRAY = VERB_FORMS_HASH.values

  CONTRACTIONS = self.set_up_dict_hash("./lib/word_lists/contractions.txt")
  CONTRACTION_VERBS = CONTRACTIONS.select {|k,v| v == 'v'}.keys

  ALL_COMMON_WITH_PART_OF_SPEECH = DICTIONARY.merge(CONTRACTIONS)

  COMMON_FORMS = DICTIONARY.keys + PLURALS.values + VERB_FORMS_HASH.values
  SO_MANY_WORDS = set_up_dict_array("./lib/word_lists/big_list")



  FREQ_FIRST_LETTER = %w(t o a w b c d s f m r h i y e g l n p u j k)
  FREQ_SECOND_LETTER = %w(h o e i a u n r t)
  FREQ_THIRD_LETTER = %w(e s a r n i)
  FREQ_LAST_LETTER = %w(e s t d n r y f l o g h a k m p u w)
  FREQ_FOLLOW_E = %w(r s n d)
  FREQ_DIGRAPH = %w(th he an in er on re ed nd ha at en es of nt ea ti to io le is ou ar as de rt ve)
  FREQ_TRIGRAPH = %w(the and tha ent ion tio for nde has nce tis oft men)
  FREQ_DOUBLE = %w(ss ee tt ff ll mm oo)




  def self.get_replist(array)
      return array.get_words_with_repeats.map{|x| x.include?("'") || x.include?("-") ? nil : x }.compact
  end

  def self.get_likely_wordlist_from_x_string(x_string, *solved_letters)
    #Deals with words with apostrophes be they contractions or...
    #puts "\n\n\nHERE\n\n\n" if x_string = "AiAX'X"

    if x_string.include?("'")
      poss = XWordSearch.match_likely_words(x_string, Vocab::CONTRACTIONS.keys, *solved_letters)
      #...possessive nouns
      if /'[s]$/ =~ x_string || /'[X]$/ =~ x_string && !solved_letters.include?('s')
        potential_possesive_nouns = XWordSearch.match_likely_words(x_string[0..-3], Vocab::NOUNS, *solved_letters)
        potential_possesive_nouns.map! {|n| n + "'s"}
        poss.concat(potential_possesive_nouns)
      end

    else
      poss = XWordSearch.match_likely_words(x_string, Vocab::DICTIONARY.keys, *solved_letters)

    end
    if poss
      if poss.length == 0
        wordlist = "NONE FOUND"
      else
        wordlist = poss
      end
    end
  end



end
