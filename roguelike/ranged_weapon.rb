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

  def fire!
    if thrown
      Settings.ready_throw(self)
    else
      if Player.has(ammo_type)
        ammo = Player.item_in_inventory_by_name(ammo_type)
        ammo.on_hit_damage = Item[ammo_type].on_hit_damage + (self.shoot_damage || 0)
        Settings.ready_shoot(self, Player.item_in_inventory_by_name(ammo_type))
      else
        Log.add "Out of ammo. Need more #{ammo_type}"
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
      range: '10',
      projectile_speed: 80,
      on_hit_damage: 3,
      thrown: true,
      weight: 0.3,
      description: "This is an arrow"
    })
    new({
      name: 'Fire Blast',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      on_hit_damage: 0,
      collided_action: Evals.explode(1, 20),
      thrown: true
    })
    new({
      name: 'Fire Ball',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      on_hit_damage: 0,
      collided_action: Evals.explode(0, 10),
      thrown: true
    })
    new({
      name: 'Poison Blast',
      icon: 'o',
      color: :light_green,
      destroy_on_collision_with: 'a',
      range: '10',
      projectile_speed: 40,
      on_hit_damage: 0,
      collided_action: Evals.poison(5, 1),
      thrown: true
    })
  end

  def self.generate_weapons
    new({
      name: 'Standard Bow',
      icon: '}',
      ammo_type: 'Arrow',
      color: :white,
      range: '10',
      shoot_damage: 5,
      thrown: false,
      weight: 3
    })
  end
end
