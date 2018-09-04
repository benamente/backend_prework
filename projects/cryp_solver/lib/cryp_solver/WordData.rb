

class WordData
  attr_accessor :cryp_text, :x_word, :possible_solutions, :solution, :part_of_speech
  attr_accessor :part_of_speech_not, :length, :count, :prev_word, :next_word
  attr_accessor :abs_location, :rel_location, :punctuation, :freq


  def initialize(cryp_text, x_word = "", abs_location, rel_location, prev_word, next_word)
    @freq = 1
    @cryp_text = cryp_text
    @x_word = x_word
    @length = cryp_text.length
    @abs_location = [abs_location]
    @rel_location = [rel_location]
    @prev_word = [prev_word]
    @next_word = [next_word]
  end

end
