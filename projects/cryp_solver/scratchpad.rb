
require "./lib/cryp_solver.rb"





# if (false) || true && false
#   p "did it"
# end




cgram_s = "Q ATF'I RFTX CTX ZTW BOOE MYTWI TEA MPO... YWI QF SZ NMVO, Q AQAF'I OJOF VOO QI NTSQFP. QI CQI SO BHTS ICO HOMH. --GCZEEQV AQEEOH"
first_guess = Guess.new()
first_guess.init_WT_from_string(cgram_s)
#
first_guess.push_to_master

#g1 = first_guess.try_for_loner('a')
# g1.check_completion
g2 = first_guess.try_for_loner('i')
pp g2
# g2.logic_loop
# g2.check_completion
#
# pp g2
