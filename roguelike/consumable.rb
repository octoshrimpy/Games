class Consumable
  include Item

  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb
  attr_accessor :execution_script

  def consume
    Log.add "You have #{usage_verb} #{name}."
    if Player.inventory.delete(self)
      Player.energize(self.restore_energy.to_i, nil)
      Player.restore(self.restore_mana.to_i, nil)
      Player.heal(self.restore_health.to_i, nil)
      Game.redraw
      sleep 0.3
      eval(execution_script)
      Game.redraw
    end
  end
end
