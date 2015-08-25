class DotEffect
  attr_accessor :duration, :effector, :effect_script

  def initialize(effector, duration, effect_script="Log.add('Hello')")
    self.effector = effector
    self.duration = duration
    self.effect_script = effect_script
    $dot_effects << self
  end

  def self.tick
    DotEffect.all.each do |dot|
      if dot && dot.effector && dot.duration > 0
        eval(dot.effect_script) if dot.effect_script
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
    {x: self.x, y: self.y}
  end

  def destroy
    $dot_effects.delete(self)
  end
end
