class Spell
  include Item

  attr_accessor :mana_cost, :range, :collided_action, :is_projectile, :projectile_speed, :non_projectile_script, :type

  def cast!(needs_verify=false)
    if needs_verify
      unless Player.inventory.select { |item| item.class == SpellBook }.map { |books| books.castable_spells }.flatten.include?(self.name)
        Log.add "I can't cast this spell"
        $gamemode = 'play'
        return false
      end
    end
    if Player.mana >= mana_cost
      if is_projectile
        Settings.ready('cast', self.dup, self.range)
      else
        Settings.ready_cast(self.dup, self.range || 0)
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
      type: 'fire',
      projectile_speed: 20,
      on_hit_damage: 0,
      collided_action: Evals.explode(1, 20, 'fire'),
      mana_cost: 5,
      description: "A slow moving projectile spell that will explode with a radius of 1 on impact or upon reaching it's furthest point. Deals immediate fire damage to all within the explosion."
    })
    new({
      name: 'Fire Ball',
      icon: 'o',
      color: :light_red,
      destroy_on_collision_with: 'a',
      range: 10,
      is_projectile: true,
      type: 'fire',
      projectile_speed: 20,
      on_hit_damage: 0,
      collided_action: Evals.explode(0, 10, 'fire'),
      mana_cost: 3,
      description: "A slow moving projectile spell that will explode upon impact or upon reaching it's furthest point. Deals immediate fire damage to the collided entity."
    })
    new({
      name: 'Poison Blast',
      icon: 'o',
      color: :light_green,
      destroy_on_collision_with: 'a',
      range: 10,
      is_projectile: true,
      type: 'poison',
      projectile_speed: 20,
      on_hit_damage: 0,
      collided_action: Evals.new_dot(5, 2, 'poison'),
      mana_cost: 2,
      description: "A slow moving projectile spell that will poison the collided entity, dealing poison damage over time."
    })
    new({
      name: 'Berserk',
      icon: 'x',
      color: :red,
      is_projectile: false,
      non_projectile_script: Evals.player_berserk(50),
      type: 'physical',
      mana_cost: 5,
      description: "Grants berserk for 50 ticks. While Berserk, the Player will have +3 speed and +50% strength. Berserk will cost 1 energy per tick and will cancel early if the Player runs out of energy."
    })
    new({
      name: 'Summon Stone',
      icon: '#',
      color: :red,
      is_projectile: false,
      range: 5,
      non_projectile_script: Evals.summon_stone,
      type: 'physical',
      mana_cost: 5,
      description: "Will summon a solid block at target location within range."
    })
  end
end
