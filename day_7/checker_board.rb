def draw_checkerboard(board_width = 9, board_height = 9, checker_width = 6, checker_height = 3)
  board_width = board_width
  board_height = board_height
  checker_width = checker_width
  checker_height = checker_height

  checker = "X" * checker_width
  checker_space = " " * checker_width
  half_board = (board_width/2.to_f).round
  row = [checker] * half_board
  row = board_width.even? ? row.map{|x| x + checker_space}.join : row.join(checker_space)
  other_row = row.chars.rotate(checker_width).join
  unless board_width.even?
    other_row[-checker_width..-1] = checker_space
  end

  n = 1
  loop do
    if n.odd?
      checker_height.times {puts row}
    end
    break if n > board_height
    if n.even?
      checker_height.times {puts other_row}
    end
    n += 1
    break if n > board_height
  end
end

draw_checkerboard

#sleep(1.2)

puts "To draw a custom checkerboard please enter an integer for board width:"
bw = gets.to_i
puts "Please enter board height:"
bh = gets.to_i
puts "Please enter checker width:"
cw = gets.to_i
puts "Please enter checker height:"
ch = gets.to_i

draw_checkerboard( bw, bh, cw, ch)
