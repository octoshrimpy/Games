class Player
  attr_accessor :x, :y, :seen, :depth, :vision_radius, :health, :mana, :max_health,
                :max_mana, :strength, :speed, :gold, :selected, :quick_bar, :energy,
                :max_energy

  def initialize
    @x = 0
    @y = 0
    @depth = 1
    @dungeon_level = 1 # 0 for town?
    @seen = []
    @gold = 0
    @selected = 0
    @quick_bar = Array.new(9) {nil}

    @vision_radius = 5
    @health = 20
    @max_health = 20
    @mana = 20
    @max_mana = 20
    @energy = 100
    @max_energy = 100
    @strength = 10
    @speed = 10
    $player = self
  end

  def self.me
    $player
  end

  def coords
    {x: Player.me.x, y: Player.me.y}
  end

  def verify_stats
    if self.health <= 0
      Log.add("You have been slaughtered.")
      Game.draw
      Game.end
    end
    self.health = self.max_health if self.health > self.max_health
    self.mana = 0 if self.mana < 0
    self.mana = self.max_mana if self.mana > self.max_mana
    self.energy = 0 if self.energy < 0
    self.energy = self.max_energy if self.energy > self.max_energy
  end

  def hurt(damage=1, src="You got hurt by an unknown source.")
    # Reflect if getting dangerously low on stats
    self.health -= damage
    Log.add(src)
  end

  def heal(regenerate=1, src="You got healed by an unknown source.")
    self.health += regenerate
    Log.add(src)
  end

  def drain(deplete=1, src="You lost mana from an unknown source.")
    self.mana -= deplete
    Log.add(src)
  end

  def restore(gain=1, src="You restored mana from an unknown source.")
    self.mana += gain
    Log.add(src)
  end

  def weaken(deplete=1, src=nil)
    self.energy -= deplete
    Log.add(src) if src
  end

  def energize(gain=1, src=nil)
    self.energy += gain
    Log.add(src) if src
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
      Dungeon.current.search_for("< ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      print "\n\rDown: "
      Dungeon.current.search_for("> ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      puts
    when ">"
      if Dungeon.current[self.y + y_dest][self.x + x_dest].uncolor == "> "
        Game.use_stairs("DOWN")
        tick = true
      end
    when "<"
      if Dungeon.current[self.y + y_dest][self.x + x_dest].uncolor == "< "
        Game.use_stairs("UP")
        tick = true
      end
      #-------------------- Game settings
    when "P"
      Game.input(true)
      binding.pry
      # Or pause?
    when "SPACE"
      tick = true
      blow_walls
      #-------------------- Battle
    when "H"
      heal
      tick = true
    end
    if (x_dest != 0 || y_dest != 0)
      unless Dungeon.current[self.y + y_dest][self.x + x_dest].is_solid?
        is_creature = false
        Creature.all.map do |creature|
          if creature.coords == {x: self.x + x_dest, y: self.y + y_dest}
            is_creature = true
            if self.energy > 0
              creature.hurt(1, "You hit #{creature.color(creature.name)}.")
            else
              Log.add("I'm out of energy!")
            end
          end
        end
        unless is_creature
          self.x += x_dest
          self.y += y_dest
        end
        if Dungeon.current[self.y][self.x] == "* "
          Dungeon.current[self.y][self.x] = "  "
          gold = rand(4) + 1
          Log.add("Gained #{gold} gold!")
          @gold += gold
        end
      else
        tick = false
      end
    end
    if tick
      self.selected = 0
      gain = (rand(5) == 0 ? 1 : 0)
      self.energy -= gain
      gain = (rand(50) == 0 ? 1 : 0)
      self.health += gain
    end
    tick
  end

  def blow_walls
    px = self.x
    py = self.y
    (-1..1).each do |x|
      (-1..1).each do |y|
        not_nil = !(Dungeon.current[y + py].nil?)
        solid_block = Dungeon.current[y + py][x + px].is_solid?
        breakable = !(Dungeon.current[y + py][x + px].is_unbreakable?)
        if not_nil && solid_block && breakable
          Dungeon.current[y + py][x + px] = "  "
        end
      end
    end
  end
end
