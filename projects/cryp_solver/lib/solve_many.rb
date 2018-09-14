require_relative "cryp_maker.rb"
require_relative "cryp_solver.rb"
require "pp"

this_folder = File.expand_path(__dir__)

quotes_to_test = File.open(this_folder + "/quotes_raw.txt", "r").read.delete('"')



arr = quotes_to_test.scan(/[\w ,:;\.\!\"\'\?^[0-9]]*[" ]*[\n]* *--[A-Z][a-z]*[ .\w]*/)

originals = arr.map{|line| line.gsub("\n", " ").upcase}.reject{|line| line.match(/[0-9]/)}

originals = originals[0..49]

cgrams = originals.map {|line| make_cgram(line)}

completeds = cgrams.map {|line| p c_solve(line)}

solved_count = 0

completeds.each_with_index do |string, i|
  if string == originals[i]
    solved_count += 1
  end
end

p 100 * solved_count/50
#finds names
# p quotes_to_test.scan(/--[A-Z][a-z]*[ .\w]*/).length
