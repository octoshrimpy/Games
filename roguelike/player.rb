class Player
  class_accessible :x, :y, :seen, :depth, :vision_radius, :health, :mana, :max_health,
                   :max_mana, :strength, :speed, :gold, :selected, :quick_bar, :energy,
                   :max_energy, :visible, :defense, :equipped, :inventory

    @@x = 0
    @@y = 0
    @@depth = 1
    @@dungeon_level = 1 #0 for town?
    @@seen = []
    @@gold = 0
    @@selected = 0
    @@quick_bar = Array.new(9) {nil}
    @@inventory = []
    @@equipped = {
      head: nil,
      torso: nil,
      left_hand: nil,
      right_hand: nil,
      ring1: nil,
      ring2: nil,
      ring3: nil,
      ring4: nil,
      waist: nil,
      leggings: nil,
      feet: nil
    }
    @@vision_radius = 5
    @@health = 20
    @@max_health = 20
    @@mana = 20
    @@max_mana = 20
    @@energy = 100
    @@max_energy = 100
    @@defense
    @@strength = 10
    @@speed = 10
    @@visible = true

  def self.coords
    {x: Player.x, y: Player.y}
  end

  def self.verify_stats
    Player.seen[Player.depth].uniq!
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

  def self.hurt(damage=1, src="You got hurt by an unknown source.")
    # Reflect if getting dangerously low on stats
    self.health -= damage
    Log.add(src)
  end

  def self.heal(regenerate=1, src="You got healed by an unknown source.")
    self.health += regenerate
    Log.add(src)
  end

  def self.drain(deplete=1, src="You lost mana from an unknown source.")
    self.mana -= deplete
    Log.add(src)
  end

  def self.restore(gain=1, src="You restored mana from an unknown source.")
    self.mana += gain
    Log.add(src)
  end

  def self.weaken(deplete=1, src=nil)
    self.energy -= deplete
    Log.add(src) if src
  end

  def self.energize(gain=1, src=nil)
    self.energy += gain
    Log.add(src) if src
  end

  def self.show
    special = "94"
    special = "47;34" unless Player.visible
    "\e[#{special}m@\e[0m "
  end

  def self.try_action(input)
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
    when "p"
      pickup_items
      tick = true
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
    when "R"

    when "I"
      Player.toggle_visibility
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
      Game.pause
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
      else
        tick = false
      end
    end
    if tick
      self.selected = 0
      gain = (rand(20) == 0 ? 1 : 0)
      self.energy -= gain
      gain = (rand(20) == 0 ? 1 : 0)
      self.health += gain
    end
    tick
  end

  def self.pickup_items
    picked_up = 0
    Gold.all.each do |gold_piece|
      if gold_piece.coords == coords
        increase = gold_piece.value
        self.gold += increase
        Log.add("Gained #{increase} gold! (#{self.gold})")
        gold_piece.destroy
        picked_up += 1
      end
    end
    Items.on_board.each do |item|
      if item.coords == coords
        self.inventory << item
        item.pickup
        Log.add "Picked up #{item.name}"
        picked_up += 1
      end
    end
    Log.add("Nothing to pick up.") if picked_up == 0
  end

  def self.toggle_visibility
    self.visible = !self.visible
  end

  def self.blow_walls
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
