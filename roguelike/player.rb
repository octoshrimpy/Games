require 'pry'
class Player
  attr_accessor :x, :y, :seen, :depth

  def initialize
    @x = 0
    @y = 0
    @depth = 1
    @dungeon_level = 1 # 0 for town?
    @seen = []
    # Vision radius
    # life
    # mp
    # str
    # speed
    # stats:
  end

  def show
    "\e[34m@ \e[0m"
  end

  def try_action(input)
    x_dest = 0
    y_dest = 0
    tick = false
    case input
      # Movement
    when "UP", "w"
      tick = true
      y_dest = -1
    when "LEFT", "a"
      tick = true
      x_dest = -1
    when "DOWN", "x"
      tick = true
      y_dest = 1
    when "RIGHT", "d"
      tick = true
      x_dest = 1
    when "q"
      tick = true
      y_dest = -1
      x_dest = -1
    when "e"
      tick = true
      y_dest = -1
      x_dest = 1
    when "c"
      tick = true
      y_dest = 1
      x_dest = 1
    when "z"
      tick = true
      y_dest = 1
      x_dest = -1
    when "s"
      tick = true
    when ">"
      if $dungeon[$player.depth][self.y + y_dest][self.x + x_dest].uncolor == ">"
        Game.use_stairs("DOWN")
        tick = true
      end
    when "<"
      if $dungeon[$player.depth][self.y + y_dest][self.x + x_dest].uncolor == "<"
        Game.use_stairs("UP")
        tick = true
      end
      # Game settings
    when "P"
      Game.input(true)
      binding.pry
      # Or pause?
    when "SPACE"
      tick = true
      blow_walls
      # Battle
    end
    if x_dest != 0 || y_dest != 0
      unless $dungeon[$player.depth][self.y + y_dest][self.x + x_dest].is_solid?
        self.x += x_dest
        self.y += y_dest
      end
    end
    tick
  end

  def blow_walls
    px = self.x
    py = self.y
    (-1..1).each do |x|
      (-1..1).each do |y|
        not_nil = !($dungeon[$player.depth][y + py].nil?)
        solid_block = $dungeon[$player.depth][y + py][x + px].is_solid?
        breakable = !($dungeon[$player.depth][y + py][x + px].is_unbreakable?)
        if not_nil && solid_block && breakable
          $dungeon[$player.depth][y + py][x + px] = "  "
        end
      end
    end
  end
end
