class Items
  def self.generate
    $items = []
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

      # MeleeWeapon.new({
      #   name:,
      #   icon:,
      #   color:,
      #   weight:,
      #   bonus_hp:,
      #   bonus_mana:,
      #   bonus_damage:,
      #   bonus_defense:
      # })
      # Two-handed??
  def self.generate_melee_weapons
    [
      MeleeWeapon.new({
        name: 'Excalibur',
        icon: '†',
        color: :light_yellow,
        weight: 12,
        bonus_hp: 50,
        bonus_mana: 50,
        bonus_damage: 10,
        bonus_defense: 0
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
      #   bonus_hp:,
      #   bonus_mana:,
      #   bonus_damage:,
      #   bonus_defense:
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
        bonus_hp: 0,
        bonus_mana: 0,
        bonus_damage: 0,
        bonus_defense: 0
      })
    ]
  end
      # MagicWeapon.new({
      #   name:,
      #   icon:,
      #   color:,
      #   range:,
      #   type:,
      #   weight:,
      #   bonus_hp:,
      #   bonus_mana:,
      #   bonus_damage:,
      #   bonus_defense:
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
      #   bonus_hp:,
      #   bonus_mana:,
      #   bonus_damage:,
      #   bonus_defense:
      # })
  def self.generate_equipment
    [
    ]
  end

end
