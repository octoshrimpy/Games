class DotEffect
  attr_accessor :duration, :effector, :damage_type, :damage_per_tick

  def initialize(options={})
    self.effector = options[:effector]
    self.duration = options[:duration]
    self.damage_type = options[:damage_type]
    self.damage_per_tick = options[:damage_per_tick]
    $dot_effects << self
  end

  def self.tick
    DotEffect.all.each do |dot|
      if dot && dot.effector.is_a?(Creature) && dot.effector.health > 0 && dot.duration > 0
        dot.effector.hurt(dot.damage_per_tick, dot.damage_type)
        dot.duration -= 1
      else
        dot.destroy
      end
    end
  end

  def self.all
    $dot_effects
  end

  def show
    icon
  end

  def coords
    {x: self.x, y: self.y, depth: self.depth}
  end

  def destroy
    $dot_effects.delete(self)
  end
end
