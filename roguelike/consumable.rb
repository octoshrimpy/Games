class Consumable
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth
  attr_accessor :restore_energy, :restore_mana, :restore_health, :usage_verb
  attr_accessor :execution_script

  def initialize(defaults)
    self.usage_verb ||= 'used'
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    $items << self
  end

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

  def show
    @color ||= :white
    "#{icon} ".color(color)
  end

  def coords
    return nil unless x && y
    {x: x, y: y}
  end

  def pickup
    self.x = nil
    self.y = nil
    self.depth = nil
  end

  def duplicate
    item = self.clone
    item.save!
    item
  end

  def save!
    $items.delete(self)
    $items << self
  end
end
