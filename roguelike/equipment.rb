class Equipment
  include Item

  attr_accessor :contains, :size # Contains an item (Quiver contains Arrow), size is how many

  def self.generate
    new({
      name: 'Quiver',
      icon: '=',
      contains: 'Arrow',
      size: 99,
      equipment_slot: :back,
      color: :green,
      weight: 6
    })
  end
end
