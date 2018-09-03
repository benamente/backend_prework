require ('pp')
class MyCar
  attr_accessor :color, :speed
  attr_reader :year, :model
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up
    @speed += 10
  end

  def slow_down
    @speed -= 10
  end

  def stop
    @speed = 0
  end

  def spray_paint(color)
    self.color = (color)
  end
end

burt = MyCar.new("1982", "brown", "chevy")
burt.speed_up

pp burt

burt.spray_paint("hot pink")

pp burt
