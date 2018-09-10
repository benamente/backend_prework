require_relative "../../modules/Vocab.rb"
require_relative "../../modules/Grammar.rb"
require_rel "../Trackers"



class DataObject
  def print_attributes(attrs)
    list = []
    if attrs == []
      return nil
    elsif attrs.is_a? Array
      attrs.each do |a|
        list << self.public_send(a).to_s
      end
    elsif attrs.is_a? Symbol
      print self.public_send(attrs)
      return
    end
    print self.public_send(list).to_uncluttered_string_limited(40)
  end
  def to_hash
    hash = {}
    self.instance_variables.each do |var|
    end
  end

end

class LetterData < DataObject
  attr_accessor :cryp_text, :name, :locations, :prev_letter, :next_letter
  attr_accessor :solution, :likely_solutions, :likely_not, :freq

  def initialize(cryp_text, info={})
    @freq = 1
    @name = cryp_text
    @cryp_text = cryp_text
    @locations = info[:locations]
    @prev_letter = info[:prev_letter]
  end

  def freq_locs

    freq_locations = []
    locations.each do
    end
  end


end


class UnigramData < DataObject
  attr_accessor :cryp_text, :x_string, :likely_solutions, :solution, :progress
  attr_accessor :parts_of_speech_not,  :parts_of_speech_likely, :part_of_speech
  attr_accessor :abs_location, :rel_location, :punctuation, :freq, :name, :commonness
  attr_accessor :length, :prev_word, :next_word, :word_or_name, :attribution

end

class WordData < UnigramData

  def initialize(cryp_text, hash ={})
    @freq = 1
    @cryp_text = cryp_text
    @name = cryp_text
    @x_string = hash[:x_string]
    @length = cryp_text.length
    @abs_location = [hash[:abs_location]]
    @rel_location = [hash[:rel_location]]
    @prev_word = [hash[:prev_word]]
    @attribution = [hash[:attribution]]
    @word_or_name = hash[:word_or_name]
    @parts_of_speech_not = []
    @parts_of_speech_likely = []
  end

  def sync_progress
    if !x_string.include?("X")
      if @likely_solutions && @likely_solutions.include?(self.x_string)
        @progress = :SOLVED
        @commonness = :COMMON
        @solution = x_string
        @part_of_speech = x_string.part_of_speech

      elsif  Vocab::SO_MANY_WORDS.include?(self.x_string)
        @progress = :SOLVED
        @commonness = :UNCOMMON
      else
        @progress = :FILLED
      end
    else
      num_solved = x_string.scan(/[a-z]/).length
      @progress = 100 * num_solved / x_string.length
    end
  end

  def lookup_likely_words
    if self.word_or_name == :word
      @likely_solutions = Vocab.get_likely_wordlist_from_x_string(x_string)
    else
      @likely_solutions = []
    end
  end

end

class PronounData < UnigramData
  attr_accessor :type


end
