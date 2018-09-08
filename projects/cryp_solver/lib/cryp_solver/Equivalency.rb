class Equivalency
end

class WordEq < Equivalency
  attr_accessor :cryp_text, :solution
  def initialize (cryp_text, solution)
    @crypt_word = cryp_text
    @solution = solution
  end
end

class LetterEq < Equivalency
  attr_accessor :cryp_letter, :solution
end
