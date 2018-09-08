require "./lib/cryp_solver/custom_array_methods.rb"
require "./lib/cryp_solver/custom_string_methods.rb"
require "./lib/cryp_solver/Vocab.rb"
require "./lib/cryp_solver/XWordSearch.rb"
require "./lib/cryp_solver/DataObjects.rb"
require_relative "Guess.rb"

require "pp"







class Tracker
  def print_with(hash={})
    atts = hash[:atts] || atts = []
    att_of_att = hash[:att_of_att] || att_of_att = {}
    limit = hash[:limit] || limit = 35

    self.array.each do |dataob|
      atts.each_with_index do |att, i|
        realat = dataob.public_send(att)
        if realat.is_a? DataObject
          print "#{realat.name.to_s}"
        else
          if realat.is_a? Array
            printlist = realat.to_uncluttered_string_limited(limit)
            print "#{printlist}"
            max_length = limit + 3
            num_spaces = max_length - printlist.length + 2
          else
            print "#{realat.to_s}"
            if realat.is_a? String
              max_length = self.array.list_attribute(att, :to_s).max_attribute(:length)
            elsif realat.is_a? Integer
              max_length = self.array.list_attribute(att, :to_s).max_attribute(:length)
            end
            num_spaces = max_length - dataob.name.length + 2
          end
        end
        if i == 0
          print ": "
        elsif i < atts.length - 1
          print "; "
        end

        print " " * num_spaces
        #print "#{x.x_string.d}"
      end
      puts "-"
    end
  end
end

class LetterTracker < Tracker
  attr_accessor :array

  def initialize(string)

    @array = string.split_and_collect_data(by: :letter)


    #
    # nested_array.each do |word|
    #   word.each do |ldata|
    #     unless @array.list_attribute(:name).include?(ldata.name)
    #       @array << ldata
    #     else
    #       ldata.instance_variables.each do |var|
    #         twin = @array.return_object_with(:name, ldata.name)
    #
    #         var_name = var.to_s.delete("@")
    #         current_value = twin.instance_variable_get(var)
    #         var_value = ldata.instance_variable_get(var)
    #         puts "#{var_name} #{var_value}"
    #         if current_value
    #           new_value = current_value + var_value
    #         else
    #           new_value = var_value
    #         end
    #         p var.to_sym
    #         twin.instance_variable_set(var.to_sym, new_value)
    #       end
    #     end
    #   end
    # end
  end

  def each
    hash.each
  end
end

class CrypTracker < Tracker
  attr_accessor :u_t, :l_t, :u_t_master, :l_t_master, :id, :progress, :original_string

  @@count = 0
  #@@l_t_master = LetterTracker.new()
  #@@u_t_master = []

  def initialize(hash={ut:nil, lt:nil, string:nil})
    if hash[:string]
      @original_string = hash[:string]
      @u_t = UnigramTracker.new(hash[:string])
      @l_t = LetterTracker.new(hash[:string])
      if hash[:ut]
        @u_t = hash[:ut].clone
        @u_t.map! {|x| x.clone}
      end
      if hash[:lt]
        @l_t = letter_tracker
      end
      @@count += 1
      @id = @@count
    end
  end

  def suggest_and_print_guesses
    suggest_guesses(self).print_with([:goodness])
  end



  #
  # def try_for_loner(c)
  #   loner = self.word_tracker.list_attribute("cryp_text").get_words_of_length(1)[0]
  #   try = Tracker.new
  #   try.letter_tracker[loner] = c
  #   try.logic_loop
  #   return try
  # end

  #applies an equivalence to the guess's word_tracker. If the 'c'ryp letter is q
  #and 's'olves to e, the argument should take the form ('q', 'e')
  def apply_eq_to_WT(c,s)
    @u_t = @u_t.map do |wd|
      cryppy_inds = wd.cryp_text.get_indices_of_letter(c)
      wd.x_string = wd.x_string.insert_at_indices(s, cryppy_inds)
      wd
    end
  end

  #returns a string of a words unsolved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'ou'
  def get_unsolved_of_word(cword)
    solved = wik_AT.keys
    x = @u_t.assoc(cword)
    return x.cryp_text.delete(solved.join)
  end

  #returns a string of a words solved letters. If input is 'fwou' and f and w have
  #equivalences in the alphatracker, returns 'fw'
  def get_solved_of_word(cword)
    solved = wik_AT.keys
    x = @u_t.assoc(cword)

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
      @letter_tracker[x] = solution_letters[i]
      i += 1
    end
  end

  #extracts what is known(wik) from alphatracker. returns, for example, {"b" => "f", "e" => "l"}
  def wik_AT
    arr = []
    @letter_tracker.each do |x|
      if x.include?("?") or x.include?("'")
        next
      else
        arr << x
      end
      return Hash[*arr.flatten]
    end
  end

  #adds possibilities (always at index 2) to a given word.  poss should be
  #an array
  def add_poss(cword, poss)
    i = @u_t.index(@u_t.assoc(cword))
    x = @u_t[i][2]
    if x.is_a? String; return end
    if i != nil
      if x == nil or x == []
        @u_t[i][2] = poss
      else
        @u_t[i][2] = x & poss
      end
    end
  end

  #adds many word and possibility pairs onto a guess's UnigramTracker. Argument 'nested' should
  #be a nested array, eg [["cqi", ["hid", "bid"]], [qi, ["if", "is"]]]
  def add_many_poss(nested)
    nested.each do |x|
      add_poss(x.cryp_text, x.x_string)
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
    @u_t.each do | x |
      if x.x_string.include?('X') && x.x_string.has_chars_besides?("X","'")
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
    @u_t.each do |x|
      unless x[2].nil?
        if x[2].length == 1
          arr << x  if x[2].join.delete("'").has_chars_besides?(*solved)
        end
      end
    end
    return arr
  end


  def find_likely_solutions(worddataobject)
    worddataobject.likely_solutions = Vocab.get_likely_wordlist_from_x_string(worddataobject.x_string)
  end

  def find_likely_solutions_for_all
    @u_t.each do |word|
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
      [x.cryp_text, Vocab.get_likely_wordlist_from_x_string(x.x_string, *self.wik_AT.values)]#, x[3]
    end
    return pws
  end
  #Marks "SOLVED" at the 2 index of all words that have been solved
  def mark_SOLVED
    @u_t.map! do |x|
      [x.cryp_text,x.x_string, x.x_string.include?('X') ? x[2] : "SOLVED", x[3]]
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

  def contra_solved_letters?(x_string, p_word )
    s_letters = self.wik_AT.values
    d = s_letters & p_word.chars
    r = false
    if d != []
      d.each do |x|
        if letter_same_for_both?(x_string, p_word, x)
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
    @u_t.each do |x|
      unless x[2].is_a? Array
        next
      end
      narrowed = []
      schs = x.x_string.delete('X')

      x[2].each do |w|
        contradicts = 0
        if contra_solved_letters?(x.x_string,w)
          contradicts += 1
        end
        schs.chars.each do |c|
          if x.x_string.get_indices_of_letter(c) != w.get_indices_of_letter(c)
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
      #pp @u_t
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
    @@a_tracker_main = letter_tracker.clone
    @@u_t_master = word_tracker.clone
  end

  def apply_AT_to_String(string)
    s = string.chars.map do |x|
      x = x.downcase
      if self.letter_tracker.keys.include?(x)
        self.letter_tracker[x]
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
    @@u_t_master
  end

  def print_solution
    puts "The puzzle has been #{self.completion}% solved. Decoded message:"
    puts apply_AT_to_String(@@original_string)
  end
end







class String

  def split_and_collect_data (options = {})

    if self.include?(" ")
      default = :word
    else
      default = :letter
    end

    by = options[:by] || by = default

    if by == :word
      items = self.downcase.split(/ /)
      proper = false
    elsif by == :letter
      items = self.downcase.chars
    end



    storarray = []
    prev_item = nil
    rel_location = 0
    items.each_with_index do |item, index|
      # if by == :letter
      #   puts "top" + storarray.inspect
      # end

      if by == :letter
        if item == " "
          rel_location = 0
        end
        unless item.letter?
          next
        end
      end


      if by == :word
        info = Grammar.get_info_from_punc_on_word(item, prev_word: prev_item)
        rel_location = info[:rel_location] || rel_location = rel_location
        sentence_type = info[:sentence_type] || sentence_type = nil
        proper = info[:proper] || proper = proper
        attribution = info[:attribution] || attribution = 0
      end

      punct = item.delete_and_return("-?;:,.!()")

      if index > 0
        prev_item_s = items[index - 1]
        prev_item = storarray.return_object_with(:cryp_text, prev_item_s)
        if by == :word
          #prev_end = storarray.return_object_with("abs_location", [index - 1])
          if prev_item && prev_item.rel_location[-1] == :end
            rel_location = 0
          end
        elsif by == :letter
          space_ind = self.index(" ", index)
          if !space_ind
            space_ind = items.length + 1
          end
          if items.length > 2
            front_loc = rel_location
            back_loc = index - space_ind
          end

        end
      end



      cryp_text = item.clone

      if by == :word
        x_string = cryp_text.x_out_nonrepeaters()
      end
      if storarray == []
        seen_before = false
      elsif storarray.list_attribute("cryp_text").include?(cryp_text)
        seen_before = true
      else
        seen_before = false
      end
      if seen_before == false
        case by
        when :word
          storarray << WordData.new(cryp_text, x_string: x_string, abs_location: index, rel_location: rel_location, prev_word: prev_item_s)
        when :letter
          storarray << LetterData.new(cryp_text, locations: [location], prev_letter: [prev_item_s])
        end
      elsif seen_before == true
        twin = storarray.return_object_with("cryp_text", cryp_text)
        case by
        when :word
          twin.abs_location.concat << index
          twin.rel_location << rel_location
          twin.prev_word.concat << prev_item
        when :letter
          twin.locations << location
          twin.prev_letter << prev_item
        end
        twin.freq += 1
      end

      if rel_location.is_a? Integer
        rel_location += 1
      end
      # if by == :letter
      #   puts "bottom" + storarray.inspect
      # end
    end

    return storarray

  end



end











class UnigramTracker < Tracker
  attr_reader :array, :progress

  def initialize(cgram_s)
    @array = cgram_s.split_and_collect_data
    self.lookup_all_likely_words
  end

  def lookup_all_likely_words
    self.array.each do |word|
      word.lookup_likely_words
    end
  end

end
