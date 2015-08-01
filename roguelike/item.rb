module Item
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth, :equipment_slot, :stack_size
  attr_accessor :bonus_strength, :bonus_defense, :bonus_accuracy, :bonus_speed, :bonus_health, :bonus_mana, :bonus_energy, :bonus_self_regen, :bonus_magic_power

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    self.stack_size ||= 1
    $items << self
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
    melee = generate_melee_weapons
    ranged = generate_ranged_weapons
    magic = generate_magic_weapons
    equipment = generate_equipment
  end

  def self.all; $items; end
  def self.count; all.count; end
  def self.[](name); all.select {|i| i.name == name }.first; end
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
    [
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
      }),
      MeleeWeapon.new({
        name: 'Rusty Dagger',
        icon: '†',
        equipment_slot: :right_hand,
        weight: 4,
        bonus_strength: 1
      })
    ]
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
    [
      RangedWeapon.new({
        name: 'Standard Bow',
        icon: '}',
        color: :white,
        range: '10',
        thrown: false,
        weight: 3,
        bonus_health: 0,
        bonus_mana: 0,
        bonus_strength: 0,
        bonus_defense: 0
      })
    ]
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
    [
    ]
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
    [
    ]
  end
end
