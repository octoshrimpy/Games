class MagicWeapon
  attr_accessor :weight, :bonus_hp, :bonus_mana, :bonus_damage, :bonus_defense, :name, :icon, :color, :x, :y, :depth
  attr_accessor :range, :type

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    $items << self
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
end
