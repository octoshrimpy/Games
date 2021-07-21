# Plural because 'Gem' is reserved by Ruby
class Gems
  attr_accessor :pickup_script, :x, :y, :coords, :depth

  def initialize(attributes)
    @x = attributes[:x]
    @y = attributes[:y]
    @depth = Player.depth
    @pickup_script = attributes[:pickup_script]
    $drops[Player.depth] ||= []
    $drops[Player.depth] << self
  end

  def destroy
    $drops[Player.depth].delete(self)
  end

  def pickup
    eval(pickup_script)
    $screen_shot_objects.delete({instance: self, x: self.x, y: self.y, depth: self.depth})
    destroy
  end

  def self.count
    all.length
  end

  def self.on_board
    $drops[Player.depth].select { |g| g.is_a?(Gems) }
  end

  def coords
    {x: @x, y: @y, depth: @depth}
  end

  def name
    "gem"
  end

  def self.name
    "gem"
  end

  def self.show(color=:light_yellow)
    "()".color(color)
  end

  def show(color=:light_yellow)
    "()".color(color)
  end
end
