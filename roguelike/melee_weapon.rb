# MeleeWeapon.new({
#   name: 'string',
#   icon: 'string-single character',
#   equipment_slot: :symbol,
#   color: :symbol,
#   weight: integer,
#   bonus_strength: integer(optional),
#   bonus_defense: integer(optional),
#   bonus_accuracy: integer(optional),
#   bonus_speed: integer(optional),
#   bonus_health: integer(optional),
#   bonus_mana: integer(optional),
#   bonus_energy: integer(optional),
#   bonus_self_regen: integer(optional)
# })
# Two-handed??

class MeleeWeapon
  include Item

  def self.generate
    new({
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
    new({
      name: 'Rusty Dagger',
      icon: '†',
      equipment_slot: :right_hand,
      weight: 4,
      bonus_strength: 1
    })
    new({
      name: 'Fire Sword',
      icon: '†',
      color: :red,
      equipment_slot: :right_hand,
      weight: 4,
      bonus_strength: 1,
      on_hit_effect: Evals.burn(5, 2)
    })
  end
end
