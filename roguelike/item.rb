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

  def should_destroy(collided_with)
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
    if self.equipment_slot
      Player.equip(self)
    elsif self.class == RangedWeapon
      self.fire!
    elsif self.respond_to?(:consume)
      self.consume
    else
      Log.add "Couldn't do anything with #{self.name}."
    end
    self
  end

  def collided_damage(power)
    5
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
     generate_ranged_weapons
     generate_magic_weapons
     generate_equipment
  end

  def self.all; $items; end
  def self.count; all.count; end
  def self.[](name); item = all.select {|i| i.name == name }.first.dup; $items << item; item; end
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
    RangedWeapon.new({
      name: 'Arrow',
      icon: '-',
      color: :white,
      destroy_on_collision_with: 'P C',
      stack_size: 50,
      range: '10',
      thrown: true,
      weight: 0.3
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
