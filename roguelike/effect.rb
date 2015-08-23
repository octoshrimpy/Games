class Effect
  attr_accessor :icon, :life, :x, :y, :name

  def initialize(name, icon, coords)
    self.icon = icon
    self.x = coords[:x]
    self.y = coords[:y]
    self.name = name
    $effects << self
  end

  def self.tick
    Effect.all.count.times do
      Effect.all.first.destroy
    end
  end

  def self.all
    $effects
  end

  def show
    icon
  end

  def coords
    {x: self.x, y: self.y}
  end

  def destroy
    $effects.delete(self)
  end
end
