# RangedWeapon.new({
#   name: 'string',
#   icon: 'string-single character',
#   color: :symbol,
#   range: integer,
#   thrown: boolean,
#   weight: integer,
#   projectile_speed: integer,
#   collided_action: 'script',
#   ammo_type: 'String',
#   bonus_strength: integer(optional),
#   bonus_defense: integer(optional),
#   bonus_accuracy: integer(optional),
#   bonus_speed: integer(optional),
#   bonus_health: integer(optional),
#   bonus_mana: integer(optional),
#   bonus_energy: integer(optional),
#   bonus_self_regen: integer(optional)
# })

class RangedWeapon
  include Item

  attr_accessor :range, :thrown, :ammo_type, :projectile_speed, :collided_action, :shoot_damage
  attr_accessor :mana_cost, :range

  def fire!
    if thrown
      Settings.ready('throw', self, self.range)
    else
      if Player.has(ammo_type)
        ammo = Player.item_in_inventory_by_name(ammo_type)
        ammo.on_hit_damage = Item[ammo_type].on_hit_damage + (self.shoot_damage || 0)
        ammo.range = (Item[ammo_type].range || 0) + (self.range || 0)
        Settings.ready('shoot', ammo, ammo.range, Player.item_in_inventory_by_name(ammo_type))
      else
        Log.add "Out of ammo. Need more #{ammo_type}."
      end
    end
    false
  end

  def self.generate
    generate_projectiles
    generate_weapons
  end

  def self.generate_projectiles
    new({
      name: 'Arrow',
      icon: '-',
      color: :white,
      destroy_on_collision_with: 'P C',
      stack_size: 15,
      range: 20,
      projectile_speed: 80,
      on_hit_damage: 3,
      thrown: true,
      weight: 0.3,
      description: "This is an arrow"
    })
  end

  def self.generate_weapons
    new({
      name: 'Standard Bow',
      icon: '}',
      ammo_type: 'Arrow',
      color: :white,
      range: 10,
      shoot_damage: 5,
      thrown: false,
      weight: 3
    })
  end
end
