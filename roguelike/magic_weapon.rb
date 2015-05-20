class MagicWeapon
  attr_accessor :weight, :bonus_hp, :bonus_mana, :bonus_damage, :bonus_defense, :name, :icon
  attr_accessor :range, :type

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    $items << self
  end
end
