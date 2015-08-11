class Consumable
  include Item

  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb
  attr_accessor :execution_script

  def consume
    if Player.inventory.delete(self)
      Log.add "You have #{usage_verb || 'used'} #{name}."
      Player.energize(self.restore_energy.to_i, nil)
      Player.restore(self.restore_mana.to_i, nil)
      Player.heal(self.restore_health.to_i, nil)
      if execution_script
        Game.redraw
        eval(execution_script)
      end
      Game.redraw
    end
  end

  def self.generate
    new({
      weight: 0.1,
      name: "Bread of Invisibility",
      usage_verb: 'consumed',
      restore_energy: 10,
      stack_size: 10,
      icon: '`',
      execution_script: "Player.visibility(10)"
    })
    new({
      weight: 0.1,
      name: "Bread Scrap",
      usage_verb: 'consumed',
      restore_energy: 2,
      stack_size: 10,
      icon: '`'
    })
    new({
      weight: 0.1,
      name: "Scroll of Unstable Teleportation",
      stack_size: 10,
      icon: '%',
      execution_script: "sleep(0.3); Player.coords = Dungeon.find_open_spaces.sample; Game.tick"
    })
    new({
      weight: 0.1,
      name: "Scroll of Flash",
      stack_size: 10,
      icon: '%',
      color: :yellow,
      execution_script: "$gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_select_position}' to choose coordinate.\""
    })
  end
end
