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
      if execution_script
        Game.redraw
        tick = eval(execution_script)
      end
    end
    Game.input(true); binding.pry;
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
      execution_script: "Player.visibility(10)"
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
      execution_script: "sleep(0.3); Player.coords = Dungeon.find_open_spaces(false).sample; Game.tick; true"
    })
    new({
      name: "Scroll of Flash",
      weight: 0.1,
      stack_size: 10,
      icon: '%',
      color: :yellow,
      execution_script: "$gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_select_position}' to choose coordinate.\"; false"
    })
    new({
      name: 'Potion of Resurrection',
      weight: 1,
      stack_size: 1,
      icon: 'u',
      color: :magenta,
      usable_after_death: true,
      execution_script: "Player.resurrect"
    })
  end
end
