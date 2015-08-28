module Item
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth, :equipment_slot, :stack_size, :description, :destroy_on_collision_with, :usable_after_death, :on_hit_effect
  attr_accessor :bonus_strength, :bonus_defense, :bonus_accuracy, :bonus_speed, :bonus_health, :bonus_mana, :bonus_energy, :bonus_self_regen, :bonus_magic_power

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    self.usable_after_death ||= false
    self.stack_size ||= 1
    $items << self
  end

  def destroy
    Player.inventory.delete(self)
    $items.delete(self)
    true
  end

  def aoe(radius, script)
    (-radius..radius).map do |rel_y|
      (-radius..radius).map do |rel_x|
        coord = {x: x + rel_x, y: y + rel_y}
        if Dungeon.current[y + rel_y] && Dungeon.current[y + rel_y][rel_x + x]
          eval(script)
        end
      end
    end
  end

  def should_destroy_on_collision(collided_with)
    return false unless destroy_on_collision_with
    cast_object = case
    when collided_with.class == Creature then 'C'
    when collided_with.class == String then collided_with.is_solid? ? 'S' : 's'
    when collided_with.class == Player then 'P'
    else 'o'
    end
    (destroy_on_collision_with.split('') + ['a']).include?(cast_object)
  end

  def use!
    return false if $gameover && !(usable_after_death)
    unless !(Player.energy <= 0 && self.class != Consumable)
      Log.add "I don't have the energy to do that."
      $message = "I don't have the energy to do that."
      $gamemode = 'play'
      Game.redraw
      return false
    end

    tick = true
    if self.equipment_slot
      tick = Player.equip(self)
    elsif self.class == RangedWeapon || self.class == MagicWeapon
      tick = self.fire!
    elsif self.respond_to?(:consume)
      tick = self.consume
    else
      Log.add "Couldn't do anything with #{self.name}."
      tick = false
    end
    Game.redraw
    tick
  end

  def collided_damage(power)
    0
  end

  def collide(collided_with)
    if should_destroy_on_collision(collided_with)
      destroy
    end
    if self.respond_to?(:collided_action) && collided_action
      eval(collided_action)
    else
      false
    end
  end

  def show
    @color ||= :white
    "#{icon} ".color(color)
  end

  def coords
    return nil unless x && y
    {x: x, y: y}
  end

  def pickup
    self.x = nil
    self.y = nil
    self.depth = nil
  end

  def duplicate
    item = self.clone
    item.save!
    item
  end

  def save!
    $items.delete(self)
    $items << self
  end

  def self.generate
     Consumable.generate
     generate_melee_weapons
     generate_projectiles
     generate_ranged_weapons
     generate_magic_weapons
     generate_equipment
  end

  def self.damage_to_coord(coord, damage, type)
    unless Dungeon.at(coord).is_solid?
      VisualEffect.new("Fire Blast Effect", "* ".color(:light_red), coord) # refactor this to be more expandable
      Creature.at(coord).each do |creature|
        creature.hurt(damage, type)
      end
    end
  end

  def self.all; $items; end
  def self.count; all.count; end
  def self.[](name)
    item = all.select {|i| i.name == name }.first
    if item
      new_item = item.dup
      $items << new_item
      new_item
    else
      Game.input true; binding.pry
    end
  end
  def self.by_name(name); item = all.select {|i| i.name == name }.first; end
  def self.on_board; all.select {|i| i.depth == Player.depth }; end
  def self.melee; all.select {|i| i.class == MeleeWeapon }; end
  def self.ranged; all.select {|i| i.class == RangedWeapon }; end
  def self.magic; all.select {|i| i.class == MagicWeapon }; end
  def self.equipment; all.select {|i| i.class == Equipment }; end
  def self.consumable; all.select {|i| i.class == Consumable }; end

  def self.equippable
    [
      melee +
      ranged +
      magic +
      equipment
    ]
  end
      # MeleeWeapon.new({
      #   name: '',
      #   icon: '',
      #   equipment_slot: :,
      #   color: :,
      #   weight: ,
      #   bonus_strength: ,
      #   bonus_defense: ,
      #   bonus_accuracy: ,
      #   bonus_speed: ,
      #   bonus_health: ,
      #   bonus_mana: ,
      #   bonus_energy: ,
      #   bonus_self_regen:
      # })
      # Two-handed??
  def self.generate_melee_weapons
    MeleeWeapon.new({
      name: 'Excalibur',
      icon: '†',
      equipment_slot: :right_hand,
      color: :light_yellow,
      weight: 12,
      bonus_health: 50,
      bonus_mana: 50,
      bonus_strength: 10,
      bonus_self_regen: 10
    })
    MeleeWeapon.new({
      name: 'Rusty Dagger',
      icon: '†',
      equipment_slot: :right_hand,
      weight: 4,
      bonus_strength: 1
    })
    MeleeWeapon.new({
      name: 'Fire Sword',
      icon: '†',
      color: :red,
      equipment_slot: :right_hand,
      weight: 4,
      bonus_strength: 1,
      on_hit_effect: Evals.burn(5, 2)
    })
  end

  def self.generate_projectiles
    RangedWeapon.new({
      name: 'Arrow',
      icon: '-',
      color: :white,
      destroy_on_collision_with: 'P C',
      stack_size: 50,
      range: '10',
      projectile_speed: 80,
      thrown: true,
      weight: 0.3,
      description: "This is an arrow"
    })
    RangedWeapon.new({
      name: 'Fire Blast',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      collided_action: Evals.explode(1, 20),
      thrown: true
    })
    RangedWeapon.new({
      name: 'Poison Blast',
      icon: 'o',
      color: :light_green,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      collided_action: Evals.poison(5, 1),
      thrown: true
    })
  end
  # Log.add(\'poisoned\')
  #
      # RangedWeapon.new({
      #   name:,
      #   icon:,
      #   color:,
      #   range:,
      #   thrown:,
      #   weight:,
      #   bonus_strength:,
      #   bonus_defense:,
      #   bonus_accuracy:,
      #   bonus_speed:,
      #   bonus_health:,
      #   bonus_mana:,
      #   bonus_energy:,
      #   bonus_self_regen:
      # })
  def self.generate_ranged_weapons
    RangedWeapon.new({
      name: 'Standard Bow',
      icon: '}',
      ammo_type: 'Arrow',
      color: :white,
      range: '10',
      thrown: false,
      weight: 3
    })
  end
      # MagicWeapon.new({
      #   name:,
      #   icon:,
      #   equipment_slot:,
      #   color:,
      #   range:,
      #   type:,
      #   weight:,
      #   bonus_strength:,
      #   bonus_defense:,
      #   bonus_accuracy:,
      #   bonus_speed:,
      #   bonus_health:,
      #   bonus_mana:,
      #   bonus_energy:,
      #   bonus_self_regen:
      # })
  def self.generate_magic_weapons
    MagicWeapon.new({
      name: 'Book of Fire Blast',
      icon: '[',
      color: :blue,
      ammo_type: 'Fire Blast',
      range: 15,
      type: 'fire',
      weight: 3,
      mana_usage: 5
    })
    MagicWeapon.new({
      name: 'Book of Poison Blast',
      icon: '[',
      color: :blue,
      ammo_type: 'Poison Blast',
      range: 15,
      type: 'poison',
      weight: 3,
      mana_usage: 5
    })
  end
      # Equipment.new({
      #   name:,
      #   icon:,
      #   color:,
      #   equipment_slot:,
      #   weight:,
      #   bonus_strength:,
      #   bonus_defense:,
      #   bonus_accuracy:,
      #   bonus_speed:,
      #   bonus_health:,
      #   bonus_mana:,
      #   bonus_energy:,
      #   bonus_self_regen:
      # })
  def self.generate_equipment
  end
end
