class Equipment
  attr_accessor :weight, :bonus_hp, :bonus_mana, :bonus_damage, :bonus_defense, :name
  attr_accessor :equipment_slot

  def initialize(defaults)
    defaults.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    $items << self
  end
end
# a = Equipment.new({name: "Excalibur"})
