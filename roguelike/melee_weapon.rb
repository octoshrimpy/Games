class MeleeWeapon
  attr_accessor :weight, :name, :icon, :color, :x, :y, :depth, :equipment_slot
  attr_accessor :bonus_strength, :bonus_defense, :bonus_accuracy, :bonus_speed, :bonus_health, :bonus_mana, :bonus_energy, :bonus_self_regen, :bonus_magic_power

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
