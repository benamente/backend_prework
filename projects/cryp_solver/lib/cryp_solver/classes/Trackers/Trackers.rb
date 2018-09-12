require "rubygems"
require "require_all"

require_rel "../../modules/basics"

require_relative "../../modules/Vocab.rb"
require_relative "../../modules/XWordSearch.rb"
require_relative "../DataObjects/DataObjects.rb"
require_relative "../Guess.rb"

require "pp"







class Tracker


  def print_with(hash={})
    atts = hash[:atts] || atts = []
    att_of_att = hash[:att_of_att] || att_of_att = {}
    limit = hash[:limit] || limit = 35

    self.all.values.each do |dataob|
      if dataob.is_a? Array
        dataob.each do |real_dataob|
          print_dataobject(real_dataob, atts, limit, array = true)
          puts "-"
        end
      else

        print_dataobject(dataob, atts, limit)
        puts "-"

      end
    end

  end

  def print_dataobject(dataob, atts, limit, array = false)

    atts.each_with_index do |att, i|
      realat = dataob.public_send(att)
      if realat.is_a? DataObject
        print "#{realat.name.to_s}"
      else
        if realat.is_a?(Array) || realat.is_a?(Hash)
          printlist = realat.to_uncluttered_string_limited(limit)
          print "#{printlist}"
          max_length = limit + 3
          num_spaces = max_length - printlist.length + 2
        else
          print "#{realat.to_s}"
          if [String, Symbol, Integer, Float, NilClass].include?(realat.class)
            if array == true
              max_length = self.all.values.flatten.list_attribute(att, :to_s).max_attribute(:length)
            else
              max_length = self.all.values.list_attribute(att, :to_s).max_attribute(:length)
            end
          end

          num_spaces = max_length - realat.to_s.length + 2
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
  end
end





class LetterTracker < Tracker
  attr_accessor :all

  def symplify_locs
    @all.values.each do |letterdata|
      sym_locs = []
      letterdata.locations.each do|location|
        from_front = location[0]
        from_back = location[1]
        if from_front == 0
          if from_back == -1
            sym_locs << :loner
          elsif from_back == -2
            sym_locs << :one_of2
          elsif from_back == -3
            sym_locs << :one_of3
          elsif from_back == -4
            sym_locs << :one_of4
          elsif from_back < -4
            sym_locs << :first
          end
        elsif from_front == 1
          if from_back == -1
            sym_locs << :last_of2
          elsif from_back == -2
            sym_locs << :mid_of3
          elsif from_back < -2
            sym_locs << :second
          end
        elsif from_front == 2
          if from_back == -1
            sym_locs << :last_of3
          elsif from_back == -2
            sym_locs << :third
          end
        elsif from_back == -1
          sym_locs << :last
        else
          sym_locs << :mid
        end
      end

      letterdata.locations = sym_locs
    end
  end

  def letter_count

    return @all.values.list_attribute(:freq).inject do |sum, n|
      n + sum
    end
  end

  def set_perc_freqs(lc)
    @all.values.each do |letterdata|
      letterdata.perc_freq = 10000 * letterdata.freq / lc / 100.0
    end
  end

  def initialize(string)

    array = string.split_into_dataObjects(by: :letter)
    @all = (array.map { |x| [x.name, x]}).to_h
    symplify_locs
    set_perc_freqs(letter_count)
    tlw_smarts
  end

  def letter_solutions
    @all.values.list_attribute(:solution).compact
  end








  module LetterSmarts
    #two_letter_word_smarts
    def tlw_smarts
      @all.values.each do |letterdata|
        if letterdata.freq_locs.include?(:one_of2)
          letterdata.likely_not += ("a".."z").to_a - Vocab::TWO_LETTER_1

        end
        if letterdata.freq_locs.include?(:last_of2)
          letterdata.likely_not += ("a".."z").to_a - Vocab::TWO_LETTER_2
        end
      end
    end
  end

  include LetterSmarts
end





class CrypTracker < Tracker
  attr_accessor :u_t, :l_t, :g_t, :u_t_master, :l_t_master, :id, :progress, :original_string, :guesses

  @@count = 0
  #@@l_t_master = LetterTracker.new()
  #@@u_t_master = []

  def initialize(hash={ut:nil, lt:nil, string:nil})
    if hash[:string]
      @original_string = hash[:string]
      @u_t = UnigramTracker.new(hash[:string])
      @l_t = LetterTracker.new(hash[:string])
      @g_t = GuessTracker.new()
      if hash[:ut]
        @u_t = hash[:ut].clone
        @u_t.map! {|x| x.clone}
      end
      if hash[:lt]
        @l_t = letter_tracker
      end
      @@count += 1
      @id = @@count
      @g_t.gather_good_guesses(self)
    end

  end

  def apply_eq(equiv)

    case equiv.word_or_letter
    when :word

      equiv.cryp_text.chars.each_with_index do |char, i|
        apply_eq(Equivalency.new(char, equiv.solution[i], :letter)) unless char == "'"
      end
    when :letter
      l_t.all[equiv.cryp_text].solution = equiv.solution
      u_t.all.values.each do |worddata|
        inds = worddata.cryp_text.get_indices_of_letter(equiv.cryp_text)
        worddata.x_string = worddata.x_string.insert_at_indices(equiv.solution, inds)
      end
    end
  end


  def update_likely_words
    u_t.all.values.each do |word|
      word.update_likely_words(l_t.letter_solutions)
      word.sync_progress
    end
  end

  def update_guesses
    @g_t.gather_good_guesses(self)
  end


  module CrypSolver
    def implement_best_guess
      implement(g_t.best_guess)
    end
    def implement(guess)
      apply_eq(guess.eq)
      update_likely_words
      g_t.gather_good_guesses(self)
    end

  end
  include CrypSolver

end













class UnigramTracker < Tracker
  attr_reader :all, :progress, :names, :words

  def initialize(cgram_s)
    array = cgram_s.split_into_dataObjects
    @all = (array.map { |x| [x.name, x]}).to_h
    @names = @all.select {|k,v| v.word_or_name == :name }
    @words = @all.select {|k,v| v.word_or_name == :word }
    self.lookup_all_likely_words
  end

  def lookup_all_likely_words
    self.all.values.each do |word|
      word.lookup_likely_words
    end
  end




end



class GuessTracker < Tracker
  attr_accessor :all
  def initialize
    @all = {}
    @literally_all
  end


  module Generate

    def gather_good_guesses(ctracker)
      @all = {}
      a = letter_guesses(ctracker.l_t)
      b = get_word_guesses(ctracker)
      guesses_to_add = b
      guesses_to_add.each do |guess|
        unless @all[guess.cryp_text]
          @all[guess.cryp_text] = [guess]
        else
          @all.merge({guess.cryp_text => guess}){|key, oldv, newv| oldv << newv}
        end
      end
    end

    def get_word_guesses(ctracker)
      b = word_guesses(ctracker.u_t)
    end

    private

    def word_guesses(ut)
      guesses = []
      ut.all.values.each do |word|
        if word.solution
          next
        elsif word.likely_solutions
          num_poss = word.likely_solutions.length
        else
          num_poss = 0
        end
        if num_poss < 50 && num_poss > 0
          goodness_arr = GuessEval.goodness_by_freq(word.likely_solutions, word_or_name: word.word_or_name)
          word.likely_solutions.each_with_index do |x, index|
            new_guess = Guess.new(:word, word.cryp_text, x, goodness_arr[index])
            binding.pry if new_guess.goodness == nil
            guesses << new_guess if new_guess.goodness > 49
          end
        end
      end
      return guesses
    end

    def letter_guesses(ct)
    end

  end

  include GuessEval
  include Generate

end
