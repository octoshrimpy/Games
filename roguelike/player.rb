class Player
  class_accessible :x, :y, :seen, :depth, :vision_radius, :health, :mana, :raw_max_health,
                   :raw_max_mana, :raw_strength, :raw_speed, :gold, :selected, :quickbar, :energy,
                   :raw_max_energy, :visible, :raw_defense, :equipped, :inventory, :autopickup,
                   :last_hit_by, :raw_self_regen, :bonus_stats, :raw_accuracy, :raw_magic_power,
                   :invisibility_ticks, :sleeping, :inventory_size, :stunned_for

  @@x = 0
  @@y = 0
  @@vision_radius = 5

  @@depth = 1
  @@dungeon_level = 1 #0 for town?
  @@seen = []

  @@selected = 0
  @@skip_pick_up = false
  @@quickbar = Array.new(9) {nil}
  @@inventory = []
  @@inventory_size = 10

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
    magic_power: 0,
    accuracy: 0,
    defense: 0,
    strength: 0,
    speed: 0,
    self_regen: 0
  }
  @@raw_accuracy = 90
  @@health = 7
  @@raw_max_health = 7
  @@mana = 7
  @@raw_max_mana = 7
  @@energy = 100
  @@raw_max_energy = 100
  @@raw_magic_power = 0
  @@raw_strength = 10
  @@raw_defense = 0
  @@raw_speed = 10
  @@raw_self_regen = 1
  @@live = true
  @@invisibility_ticks = 0

  @@visible = true
  @@sleeping = false
  @@autopickup = true
  @@last_hit_by = nil
  @@stunned_for = 0

  def self.name; "me"; end
  def self.coords; {x: Player.x, y: Player.y}; end
  def self.coords=(coord); {x: Player.x = coord[:x], y: Player.y = coord[:y]}; end

  def self.verify_stats
    if self.health <= 0 && @@live == true
      @@live = false
      Log.add("You have been slaughtered by #{last_hit_by}.")
      Game.redraw
      Game.end
    end
    self.invisibility_ticks = 0 if self.invisibility_ticks < 0
    self.health = max_health if self.health > max_health
    self.mana = 0 if self.mana < 0
    self.mana = max_mana if self.mana > max_mana
    self.energy = 0 if self.energy < 0
    self.energy = max_energy if self.energy > max_energy
  end

  def self.tick
    self.selected = 0
    loss = (rand(10) == 0 ? 1 : 0)
    self.energy -= loss
    Log.add "I'm starving." if loss > 0 && energy <= 0
    hp_gain = (rand(5) == 0 ? self_regen : 0)
    mana_gain = (rand(3) == 0 ? self_regen : 0)
    if energy > 0
      self.health += hp_gain
      self.mana += mana_gain
    else
      $sleep_condition = 'true'
    end
    Player.invisibility_ticks -= 1
    if Player.invisibility_ticks > 0
      if Player.visible
        Log.add "You have become invisible."
        Player.visibility(1)
      end
      Player.visible = false
    else
      Log.add "You have become visible." unless Player.visible
      Player.visible = true
    end
  end

  def self.hit(raw_damage, source)
    self.hurt(raw_damage - self.defense)
  end

  def self.hurt(damage=1, src="You got hurt by an unknown source.")
    # Reflect if getting dangerously low on stats
    self.health -= damage
    $sleep_condition = 'true'
    Log.add(src) if src
    ratio = (health / raw_max_health.to_f) * 100.00
    Log.add "You are critically low on health." if ratio < 20
  end

  def self.heal(regenerate=1, src="You got healed by an unknown source.")
    self.health += regenerate
    Log.add(src) if src
  end

  def self.drain(deplete=1, src="You lost mana from an unknown source.")
    self.mana -= deplete
    Log.add(src) if src
    ratio = (mana / raw_max_mana.to_f) * 100.00
    Log.add "You are critically low on mana." if ratio < 20
  end

  def self.restore(gain=1, src="You restored mana from an unknown source.")
    self.mana += gain
    Log.add(src) if src
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
    return true unless @@stunned_for == 0
    x_dest = 0
    y_dest = 0
    tick = false
    case input
    when ("1".."9") then use_quickbar(input.to_i - 1)
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
        $spawn_creatures = true
        Log.add "You go down the stairs..."
        tick = true
      end
    when $key_up_stairs
      if Dungeon.current[self.y + y_dest][self.x + x_dest].uncolor == "< "
        Game.use_stairs("UP")
        $spawn_creatures = true
        Log.add "You go up the stairs..."
        tick = true
      end
      # --------------------------------------------------- CHEATS ----------------------------
    when "v"
      print "\nUp: "
      Dungeon.current.search_for("< ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      print "\n\rDown: "
      Dungeon.current.search_for("> ").each {|d| print "(#{d[:x]}, #{d[:y]}) "}
      puts
    when "V"
      Dungeon.current.each_with_index do |row, y|
        row.each_with_index do |col, x|
          seen[depth] << {x: x, y: y}
        end
      end
      seen.uniq!
      Log.add "Cheat activated: Full vision."
      Game.draw
      # --------------------------------------------------- / CHEATS ---------------------------
    end
    if (x_dest != 0 || y_dest != 0)
      unless Dungeon.current[self.y + y_dest][self.x + x_dest].is_solid?
        is_creature = false
        Creature.current.map do |creature|
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
    pickup_items('auto') if autopickup && !(@@skip_pick_up)
    @@skip_pick_up = false
    tick
  end

  def self.use_quickbar(input)
    item = item_in_inventory_by_name(quickbar[input])
    if item
      item.use!
    else
      error = quickbar[input] ? "I don't have any #{quickbar[input]}." : "Nothing is assigned to that slot."
      Log.add(error)
      Game.redraw
    end
  end

  def self.pickup_items(method="key_press")
    picked_up_something = false
    increase = 0
    Gold.all.select {|g| g.coords == coords}.each do |gold_piece|
      increase += gold_piece.value
      Player.gold += gold_piece.value
      gold_piece.destroy
      picked_up_something = true
    end
    Log.add("Gained #{increase} gold! (#{Player.gold})") if increase > 0
    Item.on_board.select { |i| i.coords == coords }.group_by {|i| i.name }.each do |item_name, items|
      items_picked_up = []
      items.each do |item|
        self.inventory << item
        if Player.inventory_by_stacks.count > Player.inventory_size
          self.inventory.delete(item)
        else
          item.pickup
          picked_up_something = true
          items_picked_up << item
        end
      end
      if items_picked_up.count > 0
        Log.add "Picked up #{item_name}#{items_picked_up.count > 1 ? " x#{items_picked_up.count}" : ''}."
      else
        Log.add "My inventory is full. I can't pick this up."
      end
    end
    self.pickup_items('do_again') if picked_up_something
    Log.add("Nothing to pick up.") if !(picked_up_something) && method == 'key_press'
  end

  def self.strength; raw_strength + bonuses[:strength].to_i; end
  def self.magic_power; raw_magic_power + bonuses[:magic_power].to_i; end
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
        bonus[:magic_power] = bonus_stats[:magic_power].to_i + equipment.bonus_magic_power.to_i
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

  def self.inventory_by_stacks
    stacks = {}
    self.inventory.map do |item|
      stacks[item.name] ||= []
      item_out_of_place = true
      i = 2
      while item_out_of_place
        if stacks[item.name].length < item.stack_size
          stacks[item.name] << item
          item_out_of_place = false
        else
          stacks["#{item.name} (#{i})"] ||= []
          if stacks["#{item.name} (#{i})"].length < item.stack_size
            stacks["#{item.name} (#{i})"] << item
            item_out_of_place = false
          end
          i += 1
        end
      end
    end
    stacks
  end

  def self.item_in_inventory_by_name(name)
    self.inventory.select { |item| item.name == name }.first
  end

  def self.equippable_inventory(slot)
    self.inventory.select do |i|
      if i.respond_to?(:equipment_slot)
        i.equipment_slot == slot.to_sym
      end
    end
  end

  def self.give(item_name)
    if item = Item[item_name]
      Player.inventory << item
      item
    end
  end

  def self.equip(item, slot=nil)
    slot ||= item.equipment_slot if item
    if Player.equipped[slot]
      Player.inventory << Player.equipped[slot]
      Player.equipped[slot] = nil
    end
    if item
      Player.inventory.delete(item)
      Player.equipped[slot] = item
      Log.add "Equipped #{item.name}."
    end
  end

  def self.throw_item(item, direction_coords)
    Player.inventory.delete(item)

    str = Player.raw_strength
    x, y = direction_coords
    x = x > str ? str : x
    y = y > str ? str : y
    x = x < -str ? -str : x
    y = y < -str ? -str : y

    if x == 0 && y == 0
      Log.add "Dropped #{item.name}."
    else
      Log.add "Threw #{item.name}."
    end
    Projectile.new({x: Player.x + x, y: Player.y + y}, item)
  end

  def self.drop(item, show_log=true)
    Log.add "Dropped #{item.name}." if show_log
    item.x = Player.x
    item.y = Player.y
    item.depth = Player.depth
    Player.inventory.delete(item)
    @@skip_pick_up = true
  end

  def self.drop_many(items)
    Log.add "Dropped #{items.first.name} x#{items.count}."
    items.each do |item|
      drop(item, false)
    end
  end

  def self.visibility(amount)
    self.invisibility_ticks += amount
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
