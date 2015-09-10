# Equipment.new({
#   name: 'string',
#   icon: 'string-single character',
#   equipment_slot: :symbol,
#   color: :symbol,
#   weight: integer,
#   contains: 'String',
#   size: integer,
#   bonus_strength: integer(optional),
#   bonus_defense: integer(optional),
#   bonus_accuracy: integer(optional),
#   bonus_speed: integer(optional),
#   bonus_health: integer(optional),
#   bonus_mana: integer(optional),
#   bonus_energy: integer(optional),
#   bonus_self_regen: integer(optional)
# })

class Equipment
  include Item

  attr_accessor :contains, :size # Contains an item (Quiver contains Arrow), size is how many

  def self.generate
    new({
      name: 'Quiver',
      icon: '=',
      contains: 'Arrow',
      size: 99,
      equipment_slot: :back,
      color: :green,
      weight: 6
    })
  end
end
