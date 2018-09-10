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
        if realat.is_a? Array
          printlist = realat.to_uncluttered_string_limited(limit)
          print "#{printlist}"
          max_length = limit + 3
          num_spaces = max_length - printlist.length + 2
        else
          print "#{realat.to_s}"
          if realat.is_a?(String) || realat.is_a?(Symbol) || realat.is_a?(Integer)
            if array == true
              max_length = self.all.values.flatten.list_attribute(att, :to_s).max_attribute(:length)
            else
              max_length = self.all.values.list_attribute(att, :to_s).max_attribute(:length)
            end
          end
          num_spaces = max_length - realat.to_s.length + 2
          # print num_spaces
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

  def simplify_locs
    @all.each do
      x.fdsf
    end
  end

  def initialize(string)

    array = string.split_into_dataObjects(by: :letter)
    @all = (array.map { |x| [x.name, x]}).to_h


  end


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
  end


  module Generate

    def gather_good_guesses(ctracker)
      a = letter_guesses(ctracker.l_t)
      b = word_guesses(ctracker.u_t)
      guesses_to_add = b
      guesses_to_add.each do |guess|
        unless @all[guess.cryp_text]
          @all[guess.cryp_text] = [guess]
        else
          @all.merge({guess.cryp_text => guess}){|key, oldv, newv| oldv << newv}
        end
      end
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
        if num_poss < 6 && num_poss > 0
          goodness_arr = GuessEval.goodness_by_freq(word.likely_solutions)
          word.likely_solutions.each_with_index do |x, index|
            guesses << Guess.new(:word, word.cryp_text, x, goodness_arr[index])
          end
        end
      end
      return guesses
    end

    def letter_guesses(ct)
    end

  end

  include Generate

end
