require "./lib/cryp_solver/custom_array_methods.rb"
require "./lib/cryp_solver/custom_string_methods.rb"
require "./lib/cryp_solver/Vocab.rb"
require "./lib/cryp_solver/XWordSearch.rb"

require "pp"

class String
  include UsefulStrings
end

class Array
  include UsefulArrays
end


#returns an array. at 0 is the original string,
#if it finds a name attribute e.g. "-- Groucho Marx" it pops it off and puts it at index 1
def pop_name_attribution(string)
  arr = string.split(/ /)
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

#Given an array of words and an X word in the form AXBACCAnBA, eliminates all words from the array whose letters don't match the pattern of repeaters of the given word.

def eliminate_based_on_repeater_positions(x_word, array_of_words)
  a = array_of_words.select{|word| word.length == x_word.length}
  a = a.select{|word| x_word.get_indices_of_repeaters('X') == word.get_indices_of_repeaters}
end


#Given a 'replist', a list of words with repeat characters, returns a nested array(possnest), the 0 position of each array holding the original words
#the 1 position holding a list (no great than 9) of words of the same length with the same pattern of repeating characters. Words with no possibilities
#or more than 9 possibilites are cut from the list.
def get_possnest_from_replist(replist)
  poss = replist.map do |w|
    list = get_possibility_list_from_x_repword(w)
    if list != [] && list.length <= 9
      if w.is_a?(Array)
        w[1] << list
      else
        w = [w] << list
      end
    end
  end
  poss.compact!
  return poss
end











#returns true if for both words (should be same length), the given letter is
#in the same positions
def letter_same_for_both?(w1, w2, c)
  if w1.get_indices_of_letter(c) == w2.get_indices_of_letter(c)
    return true
  else
    return false
  end
end




class Guess
  attr_accessor :word_tracker, :alpha_tracker, :count, :a_tracker_main, :w_tracker_main, :names, :completion
  @@count = 0
  @@a_tracker_main = Hash[*('a'..'z').to_a.map { |x| [x] + ["?"]}.flatten]
  @@word_tracker_master = []

  def initialize(wt=@@word_tracker_master.clone, alpha_tracker=@@a_tracker_main.clone)
    @word_tracker = wt.clone
    @word_tracker.map! {|x| x.clone}
    @alpha_tracker = alpha_tracker
    @@count += 1
    @count = @@count
  end




  def init_WT_from_string(cgram_s)
    @@original_string = cgram_s
    a = pop_name_attribution(cgram_s)
    cgram = a[0]
    @names = a[1]
    cgram_punctless = cgram.delete("-,?.!:").downcase
    cgram_punctless_array = cgram_punctless.split(/ /)
    word_list = cgram_punctless_array.clone.map {|x| [x, x.x_out_nonrepeaters]}
    @word_tracker = word_list.uniq.map {|x| [x[0], x[1], x[2], x[3]]}

  end

  def try_for_loner(c)
    loner = self.word_tracker.extract(0).get_words_of_length(1)[0]
    try = Guess.new
    try.alpha_tracker[loner] = c
    try.logic_loop
    return try
  end

  #applies an equivalence to the guess's word_tracker. If the 'c'ryp letter is q
  #and 's'olves to e, the argument should take the form ('q', 'e')
  def apply_eq_to_WT(c,s)
    @word_tracker = @word_tracker.map do |x|
      cryppy_inds = x[0].get_indices_of_letter(c)
      x[1] = x[1].insert_at_indices(s, cryppy_inds)

      [x[0], x[1], x[2], x[3]]
    end
  end

  #returns a string of a words unsolved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'ou'
  def get_unsolved_of_word(cword)
    solved = wik_AT.keys
    x = @word_tracker.assoc(cword)
    return x[0].delete(solved.join)
  end

  #returns a string of a words solved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'fw'
  def get_solved_of_word(cword)
    solved = wik_AT.keys
    x = @word_tracker.assoc(cword)

    return (x[0].chars & solved).join
  end


  #Applies all equivalences stored in the alphatracker to the wordtracker
  def apply_AT_eq_to_WT
    self.wik_AT.each do |e|
      self.apply_eq_to_WT(e[0], e[-1])
    end
  end



  #applies a solved word to the guess's alphatracker. If "qpp" is known to be "too",
  #then give arguments ('qpp', 'too') so it's also known that q = t and p = o
  def apply_word_to_AT (c,s)
    cryp_letters = c.chars
    solution_letters = s.chars
    i = 0
    cryp_letters.each do |x|
      @alpha_tracker[x] = solution_letters[i]
      i += 1
    end
  end

  #extracts what is known(wik) from alphatracker. returns, for example, {"b" => "f", "e" => "l"}
  def wik_AT
    arr = []
    @alpha_tracker.each do |x|
      if x.include?("?") or x.include?("'") then next
      else
        arr << x
      end
      return Hash[*arr.flatten]
    end
  end

  #adds possibilities (always at index 2) to a given word.  poss should be
  #an array
  def add_poss(cword, poss)
    i = @word_tracker.index(@word_tracker.assoc(cword))
    x = @word_tracker[i][2]
    if x.is_a? String; return end
    if i != nil
      if x == nil or x == []
        @word_tracker[i][2] = poss
      else
        @word_tracker[i][2] = x & poss
      end
    end
  end

  #adds many word and possibility pairs onto a guess's wordtracker. Argument 'nested' should
  #be a nested array, eg [["cqi", ["hid", "bid"]], [qi, ["if", "is"]]]
  def add_many_poss(nested)
    nested.each do |x|
      add_poss(x[0], x[1])
    end
  end

  def c_letters_left
    return ('a'..'z').to_a - self.wik_AT.keys
  end

  def s_letters_left
    return ('a'..'z').to_a - self.wik_AT.values
  end




  #returns an array of words from the object's wordtracker that are partway solved
  #for example [["atf'i", "Xon'X", nil], ["qi", "iX", nil]]. Will not return fully solved or fully unsolved words
  def partway_solved
    arr = []
    @word_tracker.each do | x |
      if x[1].include?('X') && x[1].has_chars_besides?("X","'")
        arr << x
      end
    end
    return arr
  end

  #returns a list of words in the wordtracker whose poss.length = 1, but whose letters have not been
  #discovered and applied to the alpha tracker
  def one_poss_words
    arr = []
    solved = self.wik_AT.values
    @word_tracker.each do |x|
      unless x[2].nil?
        if x[2].length == 1
          arr << x  if x[2].join.delete("'").has_chars_besides?(*solved)
        end
      end
    end
    return arr
  end


  #gets a nested array of cryp words and their possible solutions from
  #the guess's partway solved words (no list of possible solutions will be
  #greater than 9)
  #could improve so it only returns if the word doesn't have any possible solutions yet?  right now, it's a bit redundant
  def get_possnest_from_pw_s
    pws = self.partway_solved
    pws.map! do |x|
      [x[0], Vocab.get_possible_wordlist_from_x_word(x[1], *self.wik_AT.values)]#, x[3]
    end
    return pws
  end
  #Marks "SOLVED" at the 2 index of all words that have been solved
  def mark_SOLVED
    @word_tracker.map! do |x|
      [x[0],x[1], x[1].include?('X') ? x[2] : "SOLVED", x[3]]
    end
  end

  #returns a two digit percentage of words that have been solved.
  def check_completion
    a = self.word_tracker.extract(2)
    if a.count("SOLVED") == 0
      @completion = 0
    else
      @completion = ((Float(a.count("SOLVED")) / Float(a.length))*100).to_i
    end
    if @completion == 100
      print_solution
      Kernel.exit()
    end
  end

  #given a c_word and p_word determines whether there is a contradiction such that
  #the p_word contains letters that have c equivalences but at the indeces where
  #that letter occurs in the p_word, its equivalent letter does not occur in the
  #c_word. Example:
  # let's say it is known that j = v
  # ["ojof", "even", "SOLVED"],
  # ["ntsqfp", "XoXinX", ["coming", "loving", "moving"]]
  # you want it to recognize that since j = v, s can't be v, therefore loving and
  #moving should "contradict". so contra_solved_letters?("XoXinX", "coming")
  # should return false (no contradiction) while contra_solved_letters?("XoXinX", "loving")
  # should return true

  def contra_solved_letters?(x_word, p_word )
    s_letters = self.wik_AT.values
    d = s_letters & p_word.chars
    r = false
    if d != []
      d.each do |x|
        if letter_same_for_both?(x_word, p_word, x)
          r = false
        else
          return true
        end
      end
    end
    return r
  end


  #Checking the letters of the word that have been solved, eliminates word possibilities
  #that contradict
  def elimate_poss
    new_posses = []
    @word_tracker.each do |x|
      unless x[2].is_a? Array
        next
      end
      narrowed = []
      schs = x[1].delete('X')

      x[2].each do |w|
        contradicts = 0
        if contra_solved_letters?(x[1],w)
          contradicts += 1
        end
        schs.chars.each do |c|
          if x[1].get_indices_of_letter(c) != w.get_indices_of_letter(c)
            contradicts += 1
          end
        end
        narrowed << w if contradicts == 0
      end
      new_posses << [x[0], narrowed] unless narrowed == x[2]
    end
    self.add_many_poss(new_posses)
  end

  #program fills in letters and words based on known words and deduction
  def logic_loop
    self.apply_AT_eq_to_WT
    stuckness = 0
    count = 0
    while (count < 100)
      #pp @word_tracker
      pp self.word_tracker

      test1 = self.get_possnest_from_pw_s

      self.add_many_poss(test1)
      self.one_poss_words.each do |x|
        self.apply_word_to_AT(x[0],x[2].join)
      end
      self.apply_AT_eq_to_WT
      count += 1
      self.mark_SOLVED
      #self.elimate_poss
      if test1 != self.get_possnest_from_pw_s
        stuckness = 0
      else
        stuckness += 1
      end
      break if stuckness > 2
    end
    puts count
  end

  #Traces the pencil marks with pen. Sets the class AT and WT variables
  #from the instance variables.
  def push_to_master
    @@a_tracker_main = alpha_tracker.clone
    @@word_tracker_master = word_tracker.clone
  end

  def apply_AT_to_String(string)
    s = string.chars.map do |x|
      x = x.downcase
      if self.alpha_tracker.keys.include?(x)
        self.alpha_tracker[x]
      else
        x
      end
    end
    return s.join
  end

  def get_AT_main
    @@a_tracker_main
  end

  def get_WT_main
    @@word_tracker_master
  end

  def print_solution
    puts "The puzzle has been #{self.completion}% solved. Decoded message:"
    puts apply_AT_to_String(@@original_string)
  end

end
