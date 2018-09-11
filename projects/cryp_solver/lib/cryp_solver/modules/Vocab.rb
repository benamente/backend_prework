require "rubygems"
require "require_all"

require_rel "basics"
require_relative "XWordSearch.rb"
require "yaml"

class Vocab

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

  this_folder = File.expand_path(__dir__)


  DICTIONARY = self.set_up_dict_hash(this_folder + "/../../word_lists/words_by_freq_with_pos.txt")
  WORDS_WITH_FREQ = YAML.load_file(this_folder + "/../../word_lists/words_with_freq.yaml")
  NOUNS = DICTIONARY.select {|k,v| v == 'n'}.keys
  PLURALS = YAML.load_file(this_folder + '/../../word_lists/plurals.yml')
  VERBS = DICTIONARY.select {|k,v| v == 'v'}.keys
  VERB_FORMS_HASH = YAML.load_file(this_folder + '/../../word_lists/verb_forms.yml')
  VERB_FORMS_ARRAY = VERB_FORMS_HASH.values

  CONTRACTIONS = self.set_up_dict_hash(this_folder + "/../../word_lists/contractions.txt")
  CONTRACTION_VERBS = CONTRACTIONS.select {|k,v| v == 'v'}.keys

  ALL_COMMON_WITH_PART_OF_SPEECH = DICTIONARY.merge(CONTRACTIONS)

  ALL_COMMON_FORMS = DICTIONARY.keys + PLURALS.values + VERB_FORMS_HASH.values
  SO_MANY_WORDS = set_up_dict_array(this_folder + "/../../word_lists/big_list.txt")


  # 
  # FEMALE_NAMES = set_up_dict_hash(this_folder + "/../../wordlists/female_names_with_pf.txt")
  # MALE_NAMES = set_up_dict_hash(this_folder + "/../../wordlists/male_names_with_pf.txt")
  # SURNAMES = set_up_dict_hash(this_folder + "/../../wordlists/surnames_with_pf.txt")
  #
  # ALL_NAMES = FEMALE_NAMES.merge(MALE_NAMES) {|key, oldval, newval| oldval > newval ? oldval : newval}.merge(SURNAMES) {|key, oldval, newval| oldval > newval ? oldval : newval}.
  #
  #
  #
  # p ALL_NAMES["Charles"]


  FREQ_FIRST_LETTER = %w(t o a w b c d s f m r h i y e g l n p u j k)
  FREQ_SECOND_LETTER = %w(h o e i a u n r t)
  FREQ_THIRD_LETTER = %w(e s a r n i)
  FREQ_LAST_LETTER = %w(e s t d n r y f l o g h a k m p u w)
  FREQ_FOLLOW_E = %w(r s n d)
  FREQ_DIGRAPH = %w(th he an in er on re ed nd ha at en es of nt ea ti to io le is ou ar as de rt ve)
  FREQ_TRIGRAPH = %w(the and tha ent ion tio for nde has nce tis oft men)
  FREQ_DOUBLE = %w(ss ee tt ff ll mm oo)

  TWO_LETTER_WORDS = %w(of to in it is be as at so we he by or on do if me my up an go no us am)
  TWO_LETTER_1 = TWO_LETTER_WORDS.map { |word| word[0]}.uniq
  TWO_LETTER_2 = TWO_LETTER_WORDS.map { |word| word[1]}.uniq

LETTER_FREQ_PERC = {a: 8.17, b: 1.49, c: 2.78, d: 4.25, e: 12.70, f: 2.23, g: 2.02,
   h: 6.09, i: 6.97, j: 0.15, k: 0.77, l: 4.03, m: 2.41, n: 6.75, o: 7.51,
   p: 1.93, q: 0.10, r: 5.99, s: 6.33, t: 9.06, u: 2.76, v: 0.98, w: 2.36,
   x: 0.15, y: 1.97, z: 0.07}


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



class String

  def uncontract
    if self == "won't"
      return "will"
    end
    if self.include?("'")
      bits = self.split("'")
      bits.each do |bit|
        if Vocab::DICTIONARY[bit]
          return bit
        end
      end
    end
    if self.include?("n't")
      return self.sub("n't", "")
    end
  end

  def base
    #does returns do
    if Vocab::DICTIONARY[self]
      return self
    end
    if ["'s", "s'"].include?(self[-2..-1])
      return self.delete_after(-3)
    end
    word = Vocab::PLURALS[self]
    return word if word
    Vocab::VERB_FORMS_HASH.each do |key, values|
      if values && values.include?(self)
        return key.to_s
      end
    end
    if Vocab::CONTRACTIONS.keys.include?(self)
      return self.uncontract.base
    end
  end




  def freq
    freq = Vocab::WORDS_WITH_FREQ[self.base].to_i
    return freq if freq
    return 1

  end
end
