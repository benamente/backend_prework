
def make_cgram(text)
  alphabet = ("a".."z").to_a
  cipherbet = alphabet.clone.shuffle
  cipher = alphabet.zip(cipherbet).to_h

  cryptext = text.downcase.chars.map do |c|
    if alphabet.include?(c)
      cipher[c]
    else
      c
    end
  end
  return cryptext.join.upcase

end

def make_gram_for_user
  puts "Enter Text:"
  text = gets.chomp
  cryptext = make_cgram(text)
  puts "Cryptogram"
  puts cryptext
  return cryptext
end

if __FILE__ == $0
  make_gram_for_user
end
