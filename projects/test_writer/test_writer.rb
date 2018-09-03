require "pp"

code = File.readlines("code.txt", "r")

written_tests = File.open("tests.txt", "w")

code = code.join

loop do

  test_case = /.*(?=\n#)/.match(code).to_s

  if test_case == ""
    break
  end



  desired_result = /#.*/.match(code).to_s

  desired_result[0] = ""

  written_tests.puts "assert_equal(#{desired_result}, #{test_case})"


  code = code.split("\n")
  code.slice!(0..2)
  code = code.join("\n")

end
