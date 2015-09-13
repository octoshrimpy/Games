# MagicWeapon.new({
#   name: 'string',
#   icon: 'string-single character',
#   equipment_slot: :symbol,
#   color: :symbol,
#   range: integer,
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

class MagicWeapon # wands
  include Item

  attr_accessor :range, :type, :mana_usage

  # def fire! # Cast Spell
  #   ammo = Item[ammo_type]
  #   if Player.mana >= ammo.mana_cost
  #     Settings.ready('shoot', self, range, ammo)
  #     Player.mana -= ammo.mana_cost
  #     false
  #   else
  #     Log.add "Not enough mana."
  #     $gamemode = 'play'
  #     Game.redraw
  #     false
  #   end
  # end

  def self.generate
  end
end
