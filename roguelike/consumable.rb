# How do I heal and get used?
class Consumable
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth
  attr_accessor :special_effect

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    $items << self
  end

  def consume
    Log.add "You have consumed #{name}."
    Player.inventory.delete(self)
    eval(special_effect)
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
