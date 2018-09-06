require "./lib/cryp_solver/custom_array_methods.rb"
require "./lib/cryp_solver/custom_string_methods.rb"
require "./lib/cryp_solver/Vocab.rb"
require "./lib/cryp_solver/XWordSearch.rb"
require "./lib/cryp_solver/WordData.rb"

require "pp"

class Array
  def print_with(data, *aspects)

    self.each do |x|
      print "#{x.name}"
      max_length = self.list_attribute(:name).max_attribute("length")
      num_spaces = max_length - x.name.length + 2

      print " " * num_spaces
      data.each do |d|
        x.print_attributes(d)

        #print "#{x.x_word.d}"
      end
      puts ""
    end
  end
end

class Object
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
end





class Tabs
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






  def suggest_and_print_guesses
    suggest_guesses(self).print_with([:goodness])
  end

  def lookup_all_likely_words
    self.word_tracker.each do |word|
    word.lookup_likely_words
    end
  end


  def try_for_loner(c)
    loner = self.word_tracker.list_attribute("cryp_text").get_words_of_length(1)[0]
    try = Tabs.new
    try.alpha_tracker[loner] = c
    try.logic_loop
    return try
  end

  #applies an equivalence to the guess's word_tracker. If the 'c'ryp letter is q
  #and 's'olves to e, the argument should take the form ('q', 'e')
  def apply_eq_to_WT(c,s)
    @word_tracker = @word_tracker.map do |wd|
      cryppy_inds = wd.cryp_text.get_indices_of_letter(c)
      wd.x_word = wd.x_word.insert_at_indices(s, cryppy_inds)
      wd
    end
  end

  #returns a string of a words unsolved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'ou'
  def get_unsolved_of_word(cword)
    solved = wik_AT.keys
    x = @word_tracker.assoc(cword)
    return x.cryp_text.delete(solved.join)
  end

  #returns a string of a words solved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'fw'
  def get_solved_of_word(cword)
    solved = wik_AT.keys
    x = @word_tracker.assoc(cword)

    return (x.cryp_text.chars & solved).join
  end


  #Applies all equivalences stored in the alphatracker to the UnigramTracker
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

  #adds many word and possibility pairs onto a guess's UnigramTracker. Argument 'nested' should
  #be a nested array, eg [["cqi", ["hid", "bid"]], [qi, ["if", "is"]]]
  def add_many_poss(nested)
    nested.each do |x|
      add_poss(x.cryp_text, x.x_word)
    end
  end

  def c_letters_left
    return ('a'..'z').to_a - self.wik_AT.keys
  end

  def s_letters_left
    return ('a'..'z').to_a - self.wik_AT.values
  end




  #returns an array of words from the object's UnigramTracker that are partway solved
  #for example [["atf'i", "Xon'X", nil], ["qi", "iX", nil]]. Will not return fully solved or fully unsolved words
  def partway_solved
    arr = []
    @word_tracker.each do | x |
      if x.x_word.include?('X') && x.x_word.has_chars_besides?("X","'")
        arr << x
      end
    end
    return arr
  end

  #returns a list of words in the UnigramTracker whose poss.length = 1, but whose letters have not been
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


  def find_likely_solutions(worddataobject)
    worddataobject.likely_solutions = Vocab.get_likely_wordlist_from_x_word(worddataobject.x_word)
  end

  def find_likely_solutions_for_all
    @word_tracker.each do |word|
      find_likely_solutions(word)
    end
  end




  #gets a nested array of cryp words and their likely solutions from
  #the guess's partway solved words (no list of likely solutions will be
  #greater than 9)
  #could improve so it only returns if the word doesn't have any likely solutions yet?  right now, it's a bit redundant
  def get_possnest_from_pw_s
    pws = self.partway_solved
    pws.map! do |x|
      [x.cryp_text, Vocab.get_likely_wordlist_from_x_word(x.x_word, *self.wik_AT.values)]#, x[3]
    end
    return pws
  end
  #Marks "SOLVED" at the 2 index of all words that have been solved
  def mark_SOLVED
    @word_tracker.map! do |x|
      [x.cryp_text,x.x_word, x.x_word.include?('X') ? x[2] : "SOLVED", x[3]]
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

  def

  #Checking the letters of the word that have been solved, eliminates word possibilities
  #that contradict
  def elimate_poss
    new_posses = []
    @word_tracker.each do |x|
      unless x[2].is_a? Array
        next
      end
      narrowed = []
      schs = x.x_word.delete('X')

      x[2].each do |w|
        contradicts = 0
        if contra_solved_letters?(x.x_word,w)
          contradicts += 1
        end
        schs.chars.each do |c|
          if x.x_word.get_indices_of_letter(c) != w.get_indices_of_letter(c)
            contradicts += 1
          end
        end
        narrowed << w if contradicts == 0
      end
      new_posses << [x.cryp_text, narrowed] unless narrowed == x[2]
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
      #pp self.word_tracker

      test1 = self.get_possnest_from_pw_s

      self.add_many_poss(test1)
      self.one_poss_words.each do |x|
        self.apply_word_to_AT(x.cryp_text,x[2].join)
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
