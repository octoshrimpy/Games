class VisualEffect
  attr_accessor :icon, :life, :x, :y, :name

  def initialize(name, icon, coords)
    self.icon = icon
    self.x = coords[:x]
    self.y = coords[:y]
    self.name = name
    $visual_effects << self
  end

  def self.tick
    VisualEffect.all.length.times do
      VisualEffect.all.first.destroy
    end
  end

  def self.all
    $visual_effects
  end

  def show
    icon
  end

  def coords
    {x: self.x, y: self.y}
  end

  def destroy
    $visual_effects.delete(self)
  end
end
