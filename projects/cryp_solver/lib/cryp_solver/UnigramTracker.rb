require_relative ("WordData.rb")
require_relative ("Guess.rb")

class UnigramTracker
  attr_reader :array_of_word_data, :array_of_proper_noun_data

  def initialize(cgram_s = "")
    @original_string = cgram_s
    a = cgram_s.pop_name_attribution
    cgram = a[0]
    word_list = cgram.downcase.split(/ /)

    proper_names_s = a[1]


    @array_of_word_data = []

    @rel_location = 1
    word_list.each_with_index do |word, i|
      abs_location = i

      @rel_location, @sentence_type = Grammar.get_info_from_punc_on_word(word)

      punct = word.delete_and_return("-?;:,.!()")

      if i > 0
        prev_word = word_list[i - 1]
        prev_word = @array_of_word_data.return_object_with(:cryp_text, prev_word)
        #p @array_of_word_data
        prev_end = @array_of_word_data.return_object_with("abs_location", [i - 1])
        if prev_end && prev_end.rel_location == [:end]
          rel_location = 1
        end
      else
        prev_word = nil
      end

      if i < word_list.length - 1
        next_word = word_list[i + 1]
      else
        next_word = nil
      end

      cryp_text = word.clone
      x_string = cryp_text.x_out_nonrepeaters()

      if @array_of_word_data == []
        seen_before = false
      elsif @array_of_word_data.list_attribute("cryp_text").include?(cryp_text)
        seen_before = true
      else
        seen_before = false
      end
      if seen_before == false
        @array_of_word_data << WordData.new(cryp_text, x_string, abs_location, rel_location, prev_word, next_word)
      else
        twin = @array_of_word_data.return_object_with("cryp_text", cryp_text)
        twin.abs_location.concat << abs_location
        twin.rel_location << rel_location
        twin.prev_word.concat << prev_word
        twin.next_word.concat << next_word
        twin.freq += 1
      end

      if rel_location.is_a? Integer
        rel_location += 1
      end

    end
  end
end
class String
  #returns an array. at 0 is the original string,
  #if it finds a name attribute e.g. "-- Groucho Marx" it pops it off and puts it at index 1
  def pop_name_attribution
    if self = "" then return self;
      arr = self.split(/ /)
      first_name = ""
      names = []
      num = 6
      if num > arr.length
        num = arr.length
      end
      arr[num..-1].each do | x |
        if x[0] == ('-') || x[0] == ('—')
          if [".","?","!"].include?(arr[arr.index(x) - 1][-1])
            first_name = x
            break
          end
        end
      end
      if first_name != ""
        n = arr.index(first_name)
        q = arr.length - n
        for i in (1..q)
          names << arr[n]
          arr.delete_at(n)
        end
      end
      return [arr.join(" "), names.join(" ")]
    end

  end
end
