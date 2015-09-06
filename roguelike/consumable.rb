class Consumable
  include Item

  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb
  attr_accessor :execution_script

  def consume
    tick = false
    if Player.inventory.delete(self)
      Log.add "You have #{usage_verb || 'used'} #{name}."
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
      name: "Bread of Invisibility",
      weight: 0.1,
      usage_verb: 'consumed',
      restore_energy: 10,
      stack_size: 10,
      icon: '`',
      execution_script: Evals.player_invisible(10)
    })
    new({
      name: "Bread Scrap",
      weight: 0.1,
      usage_verb: 'consumed',
      restore_energy: 2,
      stack_size: 10,
      icon: '`'
    })
    new({
      name: "Scroll of Unstable Teleportation",
      weight: 0.1,
      stack_size: 10,
      icon: '%',
      execution_script: Evals.unstable_teleportation
    })
    new({
      name: "Scroll of Flash",
      weight: 0.1,
      stack_size: 10,
      icon: '%',
      color: :yellow,
      execution_script: Evals.flash(5)
    })
    new({
      name: 'Potion of Resurrection',
      weight: 1,
      stack_size: 1,
      icon: 'u',
      color: :magenta,
      usable_after_death: true,
      execution_script: Evals.resurrect_player
    })
  end
end
