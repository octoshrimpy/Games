# TODO Configure defense of player and creatures to reduce damage taken.

class Player
  class_accessible :x, :y, :seen, :depth, :vision_radius, :health, :mana, :raw_max_health,
                   :raw_max_mana, :raw_strength, :raw_speed, :gold, :selected, :quick_bar, :energy,
                   :raw_max_energy, :visible, :raw_defense, :equipped, :inventory, :autopickup,
                   :last_hit_by, :raw_self_regen, :bonus_stats, :raw_accuracy

    @@x = 0
    @@y = 0
    @@vision_radius = 5

    @@depth = 1
    @@dungeon_level = 1 #0 for town?
    @@seen = []

    @@selected = 0
    @@quick_bar = Array.new(9) {nil}
    @@inventory = []
    @@gold = 0

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
    @@bonus_stats = {
      max_health: 0,
      max_mana: 0,
      max_energy: 0,
      accuracy: 0,
      defense: 0,
      strength: 0,
      speed: 0,
      self_regen: 0
    }
    @@raw_accuracy = 90
    @@health = 20
    @@raw_max_health = 20
    @@mana = 20
    @@raw_max_mana = 20
    @@energy = 100
    @@raw_max_energy = 100
    @@raw_strength = 1
    @@raw_defense = 0
    @@raw_speed = 10
    @@raw_self_regen = 1

    @@visible = true
    @@autopickup = true
    @@last_hit_by = nil

  def self.coords
    {x: Player.x, y: Player.y}
  end

  def self.verify_stats
    Player.seen[Player.depth].uniq!
    if self.health <= 0
      Log.add("You have been slaughtered by #{last_hit_by}.")
      Game.draw
      Game.end
    end
    self.health = max_health if self.health > max_health
    self.mana = 0 if self.mana < 0
    self.mana = max_mana if self.mana > max_mana
    self.energy = 0 if self.energy < 0
    self.energy = max_energy if self.energy > max_energy
  end

  def self.hurt(damage=1, src="You got hurt by an unknown source.")
    # Reflect if getting dangerously low on stats
    self.health -= damage
    Log.add(src)
    ratio = (health / raw_max_health.to_f) * 100.00
    Log.add "You are critically low on health." if ratio < 20
  end

  def self.heal(regenerate=1, src="You got healed by an unknown source.")
    self.health += regenerate
    Log.add(src)
  end

  def self.drain(deplete=1, src="You lost mana from an unknown source.")
    self.mana -= deplete
    Log.add(src)
    ratio = (mana / raw_max_mana.to_f) * 100.00
    Log.add "You are critically low on mana." if ratio < 20
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
    ratio = (energy / raw_max_energy.to_f) * 100.00
    Log.add "You are critically low on Energy." if ratio < 20
  end

  def self.show
    special = "94"
    special = "47;34" unless Player.visible
    "\e[#{special}m@\e[0m "
  end

  def self.try_action(input)
    return false unless $gamemode == 'play'
    x_dest = 0
    y_dest = 0
    tick = false
    case input
      # Movement
    when "UP", $key_move_up
      tick = true
      y_dest = -1
    when "LEFT", $key_move_left
      tick = true
      x_dest = -1
    when "DOWN", $key_move_down
      tick = true
      y_dest = 1
    when "RIGHT", $key_move_right
      tick = true
      x_dest = 1
    when $key_move_up_left
      tick = true
      y_dest = -1
      x_dest = -1
    when $key_move_up_right
      tick = true
      y_dest = -1
      x_dest = 1
    when $key_move_down_right
      tick = true
      y_dest = 1
      x_dest = 1
    when $key_move_down_left
      tick = true
      y_dest = 1
      x_dest = -1
    when $key_move_nowhere
      tick = true
    when $key_pickup_items
      pickup_items
      tick = true
    when $key_down_stairs
      if Dungeon.current[self.y + y_dest][self.x + x_dest].uncolor == "> "
        Game.use_stairs("DOWN")
        Log.add "You go down the stairs..."
        tick = true
      end
    when $key_up_stairs
      if Dungeon.current[self.y + y_dest][self.x + x_dest].uncolor == "< "
        Game.use_stairs("UP")
        Log.add "You go up the stairs..."
        tick = true
      end
      # ----------------------------------------------------CHEATS ----------------------------
    when "H"
      heal
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
      Log.add "You've become #{Player.visible ? 'visible' : 'invisible'}."
    when "P"
      Game.pause
      # Or pause?
    when "RETURN"
      tick = true
      blow_walls
      Log.add "The walls around you are blown away."
    end
    if (x_dest != 0 || y_dest != 0)
      unless Dungeon.current[self.y + y_dest][self.x + x_dest].is_solid?
        is_creature = false
        Creature.all.map do |creature|
          if creature.coords == {x: self.x + x_dest, y: self.y + y_dest}
            is_creature = true
            if self.energy > 0
              damage = (0..100).to_a.sample > accuracy ? -1 : (strength + (-1..1).to_a.sample)
              if damage == 0
                Log.add "#{creature.color(creature.name)} blocked your attack."
              elsif damage < 0
                Log.add "You missed #{creature.color(creature.name)}."
              else
                creature.hurt(damage, "You hit #{creature.color(creature.name)} for #{damage} damage.")
              end
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
      gain = (rand(10) == 0 ? 1 : 0)
      self.energy -= gain
      hp_gain = (rand(5) == 0 ? self_regen : 0)
      mana_gain = (rand(3) == 0 ? self_regen : 0)
      if energy > 0
        self.health += hp_gain
        self.mana += mana_gain
      else
      end
    end
    pickup_items('auto') if autopickup
    tick
  end

  def self.pickup_items(method="key_press")
    picked_up = 0
    Gold.all.each do |gold_piece|
      if gold_piece.coords == Player.coords
        increase = gold_piece.value
        Player.gold += increase
        Log.add("Gained #{increase} gold! (#{Player.gold})")
        gold_piece.destroy
        picked_up += 1
      end
    end
    Items.on_board.each do |item|
      if item.coords == coords
        equipped[:right_hand] = item
        # self.inventory << item
        item.pickup
        Log.add "Picked up #{item.name}"
        picked_up += 1
      end
    end
    self.pickup_items('do_again') if picked_up > 0
    Log.add("Nothing to pick up.") if picked_up == 0 && method == 'key_press'
  end

  def self.strength; raw_strength + bonuses[:strength].to_i; end
  def self.defense; raw_defense + bonuses[:defense].to_i; end
  def self.accuracy; raw_accuracy + bonuses[:accuracy].to_i; end
  def self.speed; raw_speed + bonuses[:speed].to_i; end
  def self.max_health; raw_max_health + bonuses[:max_health].to_i; end
  def self.max_mana; raw_max_mana + bonuses[:max_mana].to_i; end
  def self.max_energy; raw_max_energy + bonuses[:max_energy].to_i; end
  def self.self_regen; raw_self_regen + bonuses[:self_regen].to_i; end

  def self.bonuses
    bonus = {}
    equipped.each do |location, equipment|
      if equipment
        bonus[:strength] = bonus_stats[:strength].to_i + equipment.bonus_strength.to_i
        bonus[:defense] = bonus_stats[:defense].to_i + equipment.bonus_defense.to_i
        bonus[:accuracy] = bonus_stats[:accuracy].to_i + equipment.bonus_accuracy.to_i
        bonus[:speed] = bonus_stats[:speed].to_i + equipment.bonus_speed.to_i
        bonus[:max_health] = bonus_stats[:health].to_i + equipment.bonus_health.to_i
        bonus[:max_mana] = bonus_stats[:mana].to_i + equipment.bonus_mana.to_i
        bonus[:max_energy] = bonus_stats[:energy].to_i + equipment.bonus_energy.to_i
        bonus[:self_regen] = bonus_stats[:self_regen].to_i + equipment.bonus_self_regen.to_i
      end
    end
    bonus
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
