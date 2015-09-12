# MagicWeapon.new({
#   name: 'string',
#   icon: 'string-single character',
#   equipment_slot: :symbol,
#   color: :symbol,
#   range: integer,
#   ammo_type: 'String',
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

class MagicWeapon
  include Item

  attr_accessor :range, :type, :mana_usage, :ammo_type, :castable_spells

  def fire!
    ammo = Item[ammo_type]
    if Player.mana >= ammo.mana_cost
      Settings.ready_shoot(self, ammo)
      Player.mana -= ammo.mana_cost
      false
    else
      Log.add "Not enough mana."
      $gamemode = 'play'
      Game.redraw
      false
    end
  end

  def self.generate
    new({
      name: 'Book of Fire',
      icon: '[',
      color: :blue,
      ammo_type: 'Fire Blast',
      range: 15,
      type: 'fire',
      weight: 3,
      castable_spells: ['Fire Ball', 'Fire Blast']
    })
    new({
      name: 'Book of Poison',
      icon: '[',
      color: :blue,
      ammo_type: 'Poison Blast',
      range: 15,
      type: 'poison',
      weight: 3,
      castable_spells: ['Poison Blast']
    })
  end
end
