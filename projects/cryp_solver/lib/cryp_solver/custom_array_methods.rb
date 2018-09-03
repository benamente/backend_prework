
module UsefulArrays
    def has_els_besides?(*e)
        if self - e != []
            return true
        else
            return false
        end
    end

    #takes an array nested like [[a, b], [c, d]] and returns an array of every
    #element at the "n" index of the second depth. The above exampe would return
    #[a,c]
    def extract(n)
        arr = []
        self.each do |x|
            arr << x[n]
        end
        return arr
    end

    #returns all elements containing s
    def get_all_with(s)
        a = []
        self.each do |x|
            if x.include?(s) then a << x end
        end
        return a
    end


    #get all indices of an array that are not ""
    def non_nil_indices(array)
        a = []
        array.each do |x|
            if x != ""
              i = self.index(x)
              if a.include?(i) then i = self.index(i+1) end
              a << i
            end
        end
    end

    #get all objects(words) of an array that are 'x' length. For finding all 1,2,3 letter words
    def get_words_of_length(x)
        arr = []
        self.each do |w|
            if w.length == x then arr << w end
        end
        return arr
    end

    #gets words with repeat letters
    def get_words_with_repeats
        rep_words =[]
        self.each do |x|
            chars = x.get_repeater_chars
            if chars != [] then rep_words << x end
        end
        return rep_words
    end

    #removes all strings from an array if they don't contain a specified character at a specified index
    def remove_all_without(c, i)
        return self.map {|x| x[i] == c ? x : nil}.compact
    end

    #removes all strings from an array if they contain a specified char, or any of an array of chars
    def remove_all_with(*c)
      return nil if c.nil?

      if c.is_a? String
        return self.map {|x| x.include?(c) ? nil : x}.compact
      elsif c.is_a? Array
        if c == [[]] || c == []
          return self
        else
          return self.reject{|word| /[#{c.join}]/ =~ word}
        end
      end
    end

    #removes all arrays from an array if they cointain a nil element
    def remove_all_with_nil
        return self.map {|x| x.any?{ |e| e.nil? } ? nil : x}.compact
    end

end

class Array
  include UsefulArrays
end
