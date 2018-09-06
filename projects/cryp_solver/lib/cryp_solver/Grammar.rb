require_relative "WordData.rb"
require_relative "Vocab.rb"
require_relative "Probability.rb"

class String
  def part_of_speech
    pos = Vocab::ALL_COMMON_WITH_PART_OF_SPEECH[self]
    if pos
      return pos
    else
      return "UNKOWN"
    end
  end
end

module Grammar

  #Nouns and adjectives don't generally follow pronouns. Most english not Tarzan talk.
  def self.check_tarzan(word_or_word_tracker)
    if word_or_word_tracker.is_a? WordData
      word = word_or_word_tracker
      word.prev_word.each do |pw|
        if pw && pw.solution && pw.solution.part_of_speech == "p"
          ["n","p","j"].each do |z|
            word.parts_of_speech_not << Probability.new(z, 98)
          end
        end
      end
    else
      wt = word_or_word_tracker
      wt.each do |word|
        check_tarzan(word)
      end
    end
  end

  def self.get_info_from_punc_on_word(word)
    if ".?!;,".include?(word[-1])
      rel_location = :end
      case word[-1]
      when "."
        sentence_type = :statement
      when "!"
        sentence_type = :exclamation
      when "?"
        sentence_type = :question
      end
      return [rel_location, sentence_type]
    end
  end
end
