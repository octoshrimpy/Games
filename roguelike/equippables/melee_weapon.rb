class MeleeWeapon
  include Item

  def self.generate
    new({
      name: 'Excalibur',
      icon: '†',
      equipment_slot: :main_hand,
      color: :light_yellow,
      weight: 12,
      bonus_health: 50,
      bonus_mana: 50,
      bonus_strength: 10,
      bonus_self_regen: 10,
      description: "A powerful sword said to have been lost in time."
    })
    new({
      name: 'Rusty Dagger',
      icon: '†',
      equipment_slot: :main_hand,
      weight: 4,
      bonus_strength: 1,
      description: "A standard dagger that appears to be quite aged."
    })
    new({
      name: 'Fire Sword',
      icon: '†',
      color: :red,
      equipment_slot: :main_hand,
      weight: 4,
      bonus_strength: 1,
      on_hit_effect: Evals.new_dot(5, 2, 'fire', false),
      description: "A sword imbued with flame. Will burn enemies for a short time, dealing damage per tick."
    })
  end
end
