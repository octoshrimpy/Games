class Consumable
  include Item

  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb, :usage_verb_past
  attr_accessor :execution_script

  def initialize(options)
    @usage_verb ||= 'use'
    @usage_verb_past ||= 'used'
    super(options)
  end

  def consume
    tick = false
    if Player.inventory.delete(self)
      Log.add "You have #{usage_verb_past} #{name}."
      Player.energize(self.restore_energy.to_i, nil)
      Player.restore(self.restore_mana.to_i, nil)
      Player.heal(self.restore_health.to_i, nil)
      tick = true
      if execution_script && execution_script.length > 0
        Game.redraw
        tick = eval(execution_script)
      end
    end
    tick
  end

  def self.generate
    new({
      name: "Bread Scrap",
      weight: 0.1,
      usage_verb: 'consume',
      usage_verb_past: 'consumed',
      restore_energy: 2,
      stack_size: 20,
      icon: '`',
      description: "Restores 2 energy on consume."
    })
    new({
      name: "Bread Chunk",
      weight: 0.3,
      usage_verb: 'consume',
      usage_verb_past: 'consumed',
      restore_energy: 10,
      stack_size: 10,
      icon: '`',
      description: "Restores 10 energy on consume."
    })
    new({
      name: "Bread Loaf",
      weight: 0.5,
      usage_verb: 'consume',
      usage_verb_past: 'consumed',
      restore_energy: 30,
      stack_size: 5,
      icon: '`',
      description: "Restores 30 energy on consume."
    })
    new({
      name: "Scroll of Unstable Teleportation",
      weight: 0.1,
      stack_size: 10,
      icon: '%',
      execution_script: Evals.unstable_teleportation,
      description: 'Teleports the Player to a random location on the current floor.'
    })
    new({
      name: "Scroll of Flash",
      weight: 0.1,
      stack_size: 10,
      icon: '%',
      color: :yellow,
      execution_script: Evals.flash(5),
      description: 'Teleports the player up to 5 spaces away in any direction. Can only land on an open space that has been seen previously. Will teleport to the furthest open location.'
    })
    new({
      name: 'Potion of Resurrection',
      weight: 1,
      stack_size: 1,
      usage_verb: 'quaff',
      usage_verb_past: 'quaffed',
      icon: 'u',
      color: :magenta,
      usable_after_death: true,
      execution_script: Evals.resurrect_player,
      description: 'Usable after death, will bring the Player back to life with full health and 3 ticks of invincibility.'
    })
    new({
      name: "Potion of Invisibility",
      weight: 0.1,
      usage_verb: 'quaff',
      usage_verb_past: 'quaffed',
      stack_size: 10,
      icon: 'u',
      execution_script: Evals.player_invisible(10),
      description: "Grants invisibility for 10 ticks. While invisibile, enemies will not attack the Player because of agro, however, they will still attack the Player if they run into you."
    })
    new({
      name: "Potion of Rage",
      weight: 0.1,
      usage_verb: 'quaff',
      usage_verb_past: 'quaffed',
      stack_size: 10,
      icon: 'u',
      execution_script: Evals.player_berserk(100),
      description: "Grants berserk for 100 ticks. While Berserk, the Player will have +3 speed and +50% strength. Berserk will cost 1 energy per tick and will cancel early if the Player runs out of energy."
    })
  end
end
