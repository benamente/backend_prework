require 'rubygems'
require 'require_all'
# require './lib/cryp_solver/structs/Probability.rb'
require_rel 'cryp_solver'



require_relative "cryp_solver.rb"

def c_solve(text)
  t1 = CrypTracker.new(string: text)
  t1.solve
  t1.solution
end

def solve_me_a_cgram
  puts "Enter cryptogram, or, press enter and I'll solve one from my database."
  cgram_s = gets.chomp

  if cgram_s.length < 10
    cgram_s = "P RMF ME FCN FYUN FCN NGTNDFX, FCN TNMTRN LCM PDN XJTTMXNH FM ON PORN FM FNRR VMJ LCPF FM HM, LYRR FNRR VMJ FCPF VMJ BPI'F HM XMUNFCYIS NANI LCNI VMJ KIML VMJ BPI. PIH P RMF ME FCN FYUN YF'X VMJD EDYNIHX ... LCM FNRR VMJ VMJ BPI HM YF. --UPDK QJBKNDONDS"
  end
  t1 = CrypTracker.new(string: cgram_s)
  t1.guess_until_out_of_guesses(print: true)

  p t1.solution
end


if __FILE__ == $0
  solve_me_a_cgram
end
