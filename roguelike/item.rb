module Item
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth, :equipment_slot, :stack_size, :description, :destroy_on_collision_with, :usable_after_death
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

  def explode!(radius, damage)
    (-radius..radius).map do |rel_y|
      (-radius..radius).map do |rel_x|
        coord = {x: x + rel_x, y: y + rel_y}
        if Dungeon.current[y + rel_y] && Dungeon.current[y + rel_y][rel_x + x]
          unless Dungeon.at(coord, depth).is_solid?
            Creature.at(coord, self.depth).each do |creature|
              creature.hurt(damage, "#{creature.color(creature.name)} got blown up for #{damage.round} damage.")
            end
          end
        end
      end
    end
  end

  def should_destroy_on_collision(collided_with)
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
    tick = true
    if self.equipment_slot
      tick = Player.equip(self)
    elsif self.class == RangedWeapon || self.class == MagicWeapon
      tick = self.fire!
    elsif self.respond_to?(:consume)
      tick = self.consume
    else
      Log.add "Couldn't do anything with #{self.name}."
    end
    Game.redraw
    tick
  end

  def collided_damage(power)
    5
  end

  def collide(collided_with)
    if should_destroy_on_collision(collided_with)
      destroy
    end
    eval(collided_action) if collided_action
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
      description: "Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby. Or- enter a letter to sleep until that specific attribute has reached max. Additionally, you can follow that key with a number to sleep until that number reaches the specified amount. Example: 'h 20' will sleep until your health reaches 20. If your health is already greater, you will not sleep. You will automatically awaken early if there is danger nearby."
    })
    RangedWeapon.new({
      name: 'Fire Blast',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      collided_action: "explode!(1, 20); destroy",
      thrown: true
    })
  end
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
      spell_to_cast: 'Fire Blast',
      range: 15,
      type: 'fire',
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
