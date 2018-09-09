Dir["../../modules/basics/*.rb"].each {|file| require file }

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

    @array = string.split_into_dataObjects(by: :letter)


  end

  def each
    hash.each
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
    end
  end

  def get_guesses
    g_t << Guess.Generate
    # def suggest_and_print_guesses
    #   suggest_guesses(self).print_with([:goodness])
    # end

  end
end











  class UnigramTracker < Tracker
    attr_reader :array, :progress

    def initialize(cgram_s)
      @array = cgram_s.split_into_dataObjects
      self.lookup_all_likely_words
    end

    def lookup_all_likely_words
      self.array.each do |word|
        word.lookup_likely_words
      end
    end


  end



  class GuessTracker < Tracker
    attr_accessor :array
    def initialize
      @array = []
    end
  end
