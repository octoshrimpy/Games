class RangedWeapon
  include Item

  attr_accessor :range, :thrown, :ammo_types, :projectile_speed, :collided_action, :shoot_damage
  attr_accessor :mana_cost, :range

  def fire!
    if thrown
      Settings.ready('throw', self, self.range)
    else
      if ammo = Player.item_in_inventory_by_names(ammo_types)
        item_reference = Item.reference(ammo.name)
        ammo.on_hit_damage = item_reference.on_hit_damage + (self.shoot_damage || 0)
        ammo.range = (item_reference.range || 0) + (self.range || 0)
        Settings.ready('shoot', ammo, ammo.range)
      else
        Log.add "Out of ammo. Need more #{ammo_types.first}."
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
      weight: 0.3,
      description: "An ammo item that can be used as a projectile from a Standard Bow. When fired, gains additional range and damage when compared to bing thrown."
    })
  end

  def self.generate_weapons
    new({
      name: 'Standard Bow',
      icon: '}',
      ammo_types: ['Arrow'],
      color: :white,
      range: 10,
      shoot_damage: 5,
      thrown: false,
      weight: 3,
      description: "When used, if the Player has the appropriate ammo, fires the ammo as a projectile. Projectiles get an addition 5 damage from being fired."
    })
  end
end
