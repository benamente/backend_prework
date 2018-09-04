module UsefulStrings

  def is_upper?
    self == self.upcase
  end

  def is_lower?
    self == self.downcase
  end

  def letter?
    x = self =~ /[[:alpha:]]/
    if x == 0
      return true
    else
      return false
    end
  end

  def delete_and_return(str)
    wanted = ""
    str.chars.each do |c|
      if self.include?(c)
        wanted += c
      end
    end
    self.delete!(str)
    return wanted
  end

  #returns true if there are any characters besides the ones listed in the argument
  def has_chars_besides?(*c)
    if self.delete(c.join).length > 0
      return true
    else
      return false
    end
  end

  #gets all indices of a 'c'har in a string
  def get_indices_of_letter(c)
    self.chars.each_with_index.map { |a, i| a == c ? i : nil }.compact
  end

  #finds an 'o'ld string or char, and if it's there, replaces all instances of it with a 'n'ew one
  def find_replace(o,n)
    count = self.count(o)
    if o != 0
      count.times do
        i = self.index(o)
        self[i] = n
      end
    end
    return self
  end

  #returns the string with all its letters replaced by X's 'exc'luding given letters
  def x_out_except(*exc)
    exc.flatten!
    return self.chars.map { |ch| exc.include?(ch)? ch: "X" }.join
  end

  # given a 'c'har and an 'a'rray of indeces, returns a new string where chars in string are replaced at indeces
  def insert_at_indices(c,a)
    new_string = self.clone
    a.each do |x|
      new_string[x] = c
    end
    return new_string
  end

  # given an 'a'rray of indeces, removes chars in string at indeces
  # doesn't work for strings that contain '#'
  def remove_at_indices(a)
    a.each do |x|
      self[x] = '#'
    end
    return self.delete('#')
  end



  #if any letters are used more than once in a string, returns a unique list of those letters in an array
  def get_repeater_chars
    char_list = []
    r_chars = []
    self.chars.each do |x|
      if char_list.include?(x) && x.letter?
        r_chars << x
      end
      char_list << x
    end
    return r_chars.uniq
  end

  def has_repeater_chars?(*not_counting)
    char_list = []
    self.chars.each do |x|
      if char_list.include?(x) && x.letter?
        unless not_counting.include?(x)
          return true
        end
      end
      char_list << x
    end
    return false
  end

  #takes a word with repeat letters and replaces all non-repeat letters with X's. Upcases others.
  def x_out_nonrepeaters
    return self.x_out_except(self.get_repeater_chars, "'").upcase
  end

  #returns list of indices (as array (or nested arrays if multiple repeating characters)) of characters that repeat
  # "Yell" would return [2,3] because those are the positions of the repeating lls
  # "marketer" would return [[2,7][4,6]]
  def get_indices_of_repeaters(*exceptions)
    #if self.get_repeater_chars == [] then return [] end
    #In this program, 'X' is generally the exception. It repeats in words, but isn't counted
    arr = []
    repchars = self.get_repeater_chars
    repchars.delete(*exceptions) unless exceptions == []
    repchars.each do |x|
      arr << get_indices_of_letter(x)
    end
    return arr
  end

end

class String
  include UsefulStrings
end
