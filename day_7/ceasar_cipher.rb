puts "Enter message:"
message = gets.chomp.downcase
puts "Enter shift amount"
shift_amount = gets.chomp.to_i
alphabet = ('a'..'z').to_a
code_alphabet = alphabet.rotate(shift_amount)
alpha_hash = alphabet.zip(code_alphabet).to_h
cipher = []
message.chars.each do |char|
  if alphabet.include?(char)
    cipher << alpha_hash[char].upcase
  else
    cipher << char
  end
end

puts "Cipher:"
puts cipher.join
