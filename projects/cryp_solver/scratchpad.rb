require "pry"
require_relative "lib/cryp_solver.rb"

# if (false) || true && false
#   p "did it"
# end




# def something(options = {:just => "do it"})
#   if options[:just] == "do it"
#     puts "I did it!"
#   end
# end
#
# something()

#

# cgram_s = "Q ATF'I RFTX CTX ZTW BOOE MYTWI TEA MPO... YWI QF SZ NMVO, Q AQAF'I OJOF VOO QI NTSQFP. QI CQI SO BHTS ICO HOMH. --GCZEEQV AQEEOH"
# cgram_s = "QKFX FX Z QEXQ ID QKE EAERCENWV ZGERQ XVXQEA. QKFX FX INGV Z QEXQ."
# cgram_s = "K AEMS QSEPUSI RMSP BAS HSEPX BAEB VASU RUS'X GKUI KX GEIS JZ, BAKX IKGKUKXASX NSEP. --PRXE ZEPTX"
cgram_s = "P RMF ME FCN FYUN FCN NGTNDFX, FCN TNMTRN LCM PDN XJTTMXNH FM ON PORN FM FNRR VMJ LCPF FM HM, LYRR FNRR VMJ FCPF VMJ BPI'F HM XMUNFCYIS NANI LCNI VMJ KIML VMJ BPI. PIH P RMF ME FCN FYUN YF'X VMJD EDYNIHX ... LCM FNRR VMJ VMJ BPI HM YF. --UPDK QJBKNDONDS"
t1 = CrypTracker.new(string: cgram_s)
#
count = 1
loop do
  t1.g_t.print_with(atts:[:cryp_text, :solution, :goodness])

  puts ""
  t1.implement_best_guess
  t1.u_t.print_with(atts:[:name, :x_string, :likely_solutions, :word_or_name])

  break if t1.g_t.all == {}
  # break if count == 1
  count +=1
end

# p t1.solution

 # t1.u_t.print_with(atts:[:name, :x_string, :likely_solutions, :word_or_name])
# t1.l_t.print_with(atts:[:name, :perc_freq, :freq, :likely_not], limit: 50)
 # t1.g_t.print_with(atts:[:cryp_text, :solution, :goodness])
