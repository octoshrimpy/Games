require 'pry'
class Player
  attr_accessor :x, :y, :seen

  def initialize
    @x = 0
    @y = 0
    @dungeon_level = 1 # 0 for town?
    @seen = []
    # life
    # mp
    # str
    # speed
    # stats:
  end

  def show
    "\e[34m@ \e[0m"
  end

  def try_move(direction)
    x_dest = 0
    y_dest = 0
    case direction
    when "LEFT" then x_dest = -1
    when "RIGHT" then x_dest = 1
    when "UP" then y_dest = -1
    when "DOWN" then y_dest = 1
    end
    unless $dungeon[self.y + y_dest][self.x + x_dest].is_solid?
      self.x += x_dest
      self.y += y_dest
    end
  end
end
