require_relative "Vocab.rb"
require_relative "Grammar.rb"

class UnigramData
  attr_accessor :cryp_text, :x_word, :likely_solutions, :solution, :progress
  attr_accessor :parts_of_speech_not,  :parts_of_speech_likely, :part_of_speech
  attr_accessor :abs_location, :rel_location, :punctuation, :freq, :name, :commonness
  attr_accessor :length, :prev_word, :next_word
end
class WordData < UnigramData

  def initialize(cryp_text, x_word = "", abs_location, rel_location, prev_word, next_word)
    @freq = 1
    @cryp_text = cryp_text
    @name = cryp_text
    @x_word = x_word
    @length = cryp_text.length
    @abs_location = [abs_location]
    @rel_location = [rel_location]
    @prev_word = [prev_word]
    @next_word = [next_word]
    @parts_of_speech_not = []
    @parts_of_speech_likely = []
  end

  def sync_progress
    if !x_word.include?("X")
      if @likely_solutions && @likely_solutions.include?(self.x_word)
        @progress = :SOLVED
        @commonness = :COMMON
        @solution = x_word
        @part_of_speech = x_word.part_of_speech

      elsif  Vocab::SO_MANY_WORDS.include?(self.x_word)
        @progress = :SOLVED
        @commonness = :UNCOMMON
      else
        @progress = :FILLED
      end
    else
      num_solved = x_word.scan(/[a-z]/).length
      @progress = 100 * num_solved / x_word.length
    end
  end

  def lookup_likely_words
    @likely_solutions = Vocab.get_likely_wordlist_from_x_word(x_word)
  end


end

class PronounData < UnigramData
  attr_accessor :Person_or_object

end
