
require "./lib/cryp_solver.rb"





# if (false) || true && false
#   p "did it"
# end

#p ["fdfd","fdfs","dlsfkhjs", "dsf","sdf", "sdfsd", "sdfsfsdfdssdfdsfds", "dfsdfsdfsdfsdgsdgsgsdg"].to_uncluttered_string_limited(40)


cgram_s = "Q ATF'I RFTX CTX ZTW BOOE MYTWI TEA MPO... YWI QF SZ NMVO, Q AQAF'I OJOF VOO QI NTSQFP. QI CQI SO BHTS ICO HOMH. --GCZEEQV AQEEOH"
g1 = Guess.new()
g1.init_WT_from_string(cgram_s)


g1.print_WT_with("prev_word")
# g1.apply_eq_to_WT("q", "i")
# g1.find_possible_solutions_for_all
#
# #p g1.word_tracker[0]
# g1.print_WT_with("possible_solutions")
#
# self.add_many_poss(test1)
# self.one_poss_words.each do |x|
#   self.apply_word_to_AT(x.cryp_text,x[2].join)
# end
# self.apply_AT_eq_to_WT
# count += 1
# self.mark_SOLVED

#
# first_guess = first_guess.try_for_loner('i')
# pp first_guess
#
# first_guess.print_WT_with("x_word")
# #
# first_guess.push_to_master
#
# #g1 = first_guess.try_for_loner('a')
# # g1.check_completion
# g2 = first_guess.try_for_loner('i')
# pp g2
# # g2.logic_loop
# # g2.check_completion
# #
# # pp g2
