# Spell.new({
#   name: 'string',
#   icon: 'string-single character',
#   color: :symbol,
#   destroy_on_collision_with: '',
#   range: integer,
#   mana_cost: integer,
#   collided_action: 'script'
#   is_projectile: boolean,
#   projectile_speed: integer,
#   non_projectile_script: 'script'
# })

class Spell
  include Item

  attr_accessor :mana_cost, :range, :collided_action, :is_projectile, :projectile_speed, :non_projectile_script

  def cast!(needs_verify=false)
    if needs_verify
      unless Player.inventory.select { |item| item.class == SpellBook }.map { |books| books.castable_spells }.flatten.include?(self.name)
        Log.add "I can't cast this spell"
        $gamemode = 'play'
        return false
      end
    end
    if Player.mana >= mana_cost
      Player.mana -= mana_cost
      if is_projectile
        Settings.ready('cast', self, self.range)
      else
        Settings.ready_cast(self, self.range)
      end
    else
      Log.add "Not enough Mana."
      $gamemode = 'play'
    end
    Game.redraw unless needs_verify
    false
  end

  def self.generate
    new({
      name: 'Fire Blast',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: 10,
      is_projectile: true,
      projectile_speed: 30,
      collided_action: Evals.explode(1, 20, 'fire'),
      mana_cost: 5
    })
    new({
      name: 'Fire Ball',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: 10,
      is_projectile: true,
      projectile_speed: 30,
      on_hit_damage: 0,
      collided_action: Evals.explode(0, 10, 'fire'),
      mana_cost: 3
    })
    new({
      name: 'Poison Blast',
      icon: 'o',
      color: :light_green,
      destroy_on_collision_with: 'a',
      range: 10,
      is_projectile: true,
      projectile_speed: 30,
      on_hit_damage: 0,
      collided_action: Evals.new_dot(5, 2, 'poison'),
      mana_cost: 2
    })
  end
end
