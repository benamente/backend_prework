
module UsefulArrays

  def max_attribute(attribute)
    max = 0
    self.each do |x|
      if x && x.public_send(attribute) > max
        max = x.public_send(attribute)
      end
    end
    return max
  end

  def list_attribute(attribute, att_of_att = nil)
    list = []
    self.each do |x|
      if att_of_att
        list << x.public_send(attribute).public_send(att_of_att)
      else
        list << x.public_send(attribute)
      end
    end
    return list
  end

  def return_object_with(attribute, value)

    self.flatten.each do |x|
      if x.public_send(attribute) == value
        return x
      end
    end
    return nil
  end

  def return_objects_with(attribute, value)
    new_arr = []
    self.flatten.each do |x|
      # binding.pry if x.is_a?(Array)

      if x.public_send(attribute) == value
        new_arr << x
      end
    end
    return new_arr
  end

  def to_uncluttered_string
    string = ""
    self.each_with_index do |value, index|
      unless index == 0
        string += " "
      end
      string += value
      unless index == self.length - 1
        string += ","
      end
    end
    return string
  end

#prints an uncluttered string no more than limit chars long. Says how many more items are in the array
  def to_uncluttered_string_limited(limit)
    string = ""
    self.each_with_index do |value, index|
      unless index == 0
        string += " "
      end
      if value == nil
        string += "---"
      elsif
        string += value.to_s
      end
      unless index == self.length - 1
        string += ","
      end
      next_length = 0
      if self[index + 1]
        next_length = self[index +1].to_s.length
      end
      if string.length + next_length > limit - 9
        string += " & #{self.length - (index + 1)} more"
        break
      end
    end
    return string
  end


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

    def to_f
      self[0].to_f
    end



    #removes all arrays from an array if they cointain a nil element
    def remove_all_with_nil
        return self.map {|x| x.any?{ |e| e.nil? } ? nil : x}.compact
    end

end

class Array
  include UsefulArrays
end
