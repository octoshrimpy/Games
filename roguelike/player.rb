class Player
  attr_accessor :x, :y, :seen, :depth, :vision_radius, :health, :mana, :max_health,
                :max_mana, :strength, :speed

  def initialize
    @x = 0
    @y = 0
    @depth = 1
    @dungeon_level = 1 # 0 for town?
    @seen = []

    @vision_radius = 5
    @health = 100
    @max_health = 100
    @mana = 100
    @max_mana = 100
    @strength = 10
    @speed = 10
  end

  def self.me
    $player
  end

  def coords
    {x: Player.me.x, y: Player.me.y}
  end

  def verify_stats
    if self.health <= 0
      $log << "You have been slaughtered."
      Game.draw
      Game.end
    end
    self.health = self.max_health if self.health > self.max_health
    self.mana = 0 if self.mana < 0
    self.mana = self.max_mana if self.mana > self.max_mana
  end

  def hurt(damage=1, src="You got hurt by an unknown source.")
    # Reflect if getting dangerously low on stats
    self.health -= damage
    $log << src
    verify_stats
  end

  def heal(regenerate=1, src="You got healed by an unknown source.")
    self.health += regenerate
    $log << src
    verify_stats
  end

  def drain(deplete=1, src="You lost mana from an unknown source.")
    self.mana -= deplete
    $log << src
    verify_stats
  end

  def restore(gain=1, src="You restored mana from an unknown source.")
    self.mana += gain
    $log << src
    verify_stats
  end

  def show
    "\e[94m@ \e[0m"
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
    when "S"
      print "\nUp: "
      $dungeon[Player.me.depth].search_for("< ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      print "\n\rDown: "
      $dungeon[Player.me.depth].search_for("> ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      puts
    when ">"
      if $dungeon[Player.me.depth][self.y + y_dest][self.x + x_dest].uncolor == ">"
        Game.use_stairs("DOWN")
        tick = true
      end
    when "<"
      if $dungeon[Player.me.depth][self.y + y_dest][self.x + x_dest].uncolor == "<"
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
    when "h"
      hurt
      tick = true
    when "j"
      drain
      tick = true
    end
    if x_dest != 0 || y_dest != 0
      unless $dungeon[Player.me.depth][self.y + y_dest][self.x + x_dest].is_solid?
        self.x += x_dest
        self.y += y_dest

        $npcs[Player.me.depth].each do |creature|
          if creature.coords == Player.me.coords
            creature.hurt(1, "You stomped on #{creature.color(creature.name)}.")
          end
        end
      end
    end
    tick
  end

  def blow_walls
    px = self.x
    py = self.y
    (-1..1).each do |x|
      (-1..1).each do |y|
        not_nil = !($dungeon[Player.me.depth][y + py].nil?)
        solid_block = $dungeon[Player.me.depth][y + py][x + px].is_solid?
        breakable = !($dungeon[Player.me.depth][y + py][x + px].is_unbreakable?)
        if not_nil && solid_block && breakable
          $dungeon[Player.me.depth][y + py][x + px] = "  "
        end
      end
    end
  end
end
