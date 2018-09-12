require "./lib/cryp_solver.rb"

puts "Enter Text:"

alphabet = ("a".."z").to_a
cipherbet = alphabet.clone.shuffle
cipher = alphabet.zip(cipherbet).to_h

text = gets.chomp
cryptext = text.downcase.chars.map do |c|
  if c.letter?
    cipher[c]
  else
    c
  end
end

puts cryptext.join.upcase
