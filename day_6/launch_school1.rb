

module Playable
  def play
    puts "doo doo, doo doo, doo"
  end
end

class Music
  include Playable
end

song = Music.new()

song.play
