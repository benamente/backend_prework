
require_relative "lib/cryp_solver.rb"

# if (false) || true && false
#   p "did it"
# end

class B
  attr_accessor :a
  def initialize
    @a = []
  end
end

thing = B.new
p thing.a



# def something(options = {:just => "do it"})
#   if options[:just] == "do it"
#     puts "I did it!"
#   end
# end
#
# something()

#

cgram_s = "Q ATF'I RFTX CTX ZTW BOOE MYTWI TEA MPO... YWI QF SZ NMVO, Q AQAF'I OJOF VOO QI NTSQFP. QI CQI SO BHTS ICO HOMH. --GCZEEQV AQEEOH"
t1 = CrypTracker.new(string: cgram_s)


t1.u_t.print_with(atts:[:name, :x_string, :likely_solutions, :word_or_name])
t1.l_t.print_with(atts:[:name, :locations])
t1.g_t.print_with(atts:[:name])
