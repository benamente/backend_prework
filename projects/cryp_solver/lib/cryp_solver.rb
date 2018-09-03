require "./lib/cryp_solver/custom_array_methods.rb"
require "./lib/cryp_solver/custom_string_methods.rb"
require "./lib/cryp_solver/Guess.rb"
require "./lib/cryp_solver/Vocab.rb"
require "pp"

class Array
  include UsefulArrays
end

class String
  include UsefulStrings
end



def something
  return "something"
end
