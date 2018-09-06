original = File.open("./lib/word_lists/words_by_freq_with_pos.txt", "r")
new_file = File.new("./lib/word_lists/words_by_freq_with_pos2.txt", "w")

new_file.puts original.readlines.map {|x| x.downcase}
