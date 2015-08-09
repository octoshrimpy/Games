class Consumable
  include Item

  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb
  attr_accessor :execution_script

  def consume
    Log.add "You have #{usage_verb || 'used'} #{name}."
    if Player.inventory.delete(self)
      Player.energize(self.restore_energy.to_i, nil)
      Player.restore(self.restore_mana.to_i, nil)
      Player.heal(self.restore_health.to_i, nil)
      if execution_script
        Game.redraw
        sleep 0.3
        eval(execution_script)
      end
      Game.redraw
    end
  end

  def self.generate
    Consumable.new({
      weight: 0.1,
      name: "Bread of Invisibility",
      usage_verb: 'consumed',
      restore_energy: 10,
      stack_size: 10,
      icon: '`',
      execution_script: "Player.visibility(10)"
    })
    Consumable.new({
      weight: 0.1,
      name: "Bread Scrap",
      usage_verb: 'consumed',
      restore_energy: 2,
      stack_size: 10,
      icon: '`'
    })
    Consumable.new({
      weight: 1,
      name: "Scroll of Unstable Teleportation",
      stack_size: 10,
      icon: '%',
      execution_script: "Player.coords = Dungeon.find_open_spaces.sample"
    })
  end
end
