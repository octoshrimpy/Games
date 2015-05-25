class Gold
  attr_accessor :value, :x, :y, :coords

  def initialize(attributes)
    @x = attributes[:x]
    @y = attributes[:y]
    @value = attributes[:value]
    $drops[Player.depth] ||= []
    $drops[Player.depth] << self
  end

  def destroy
    $drops[Player.depth].delete(self)
  end

  def self.count
    all.length
  end

  def self.all
    $drops[Player.depth]
  end

  def coords
    {x: @x, y: @y}
  end

  def name
    "gold"
  end

  def self.name
    "gold"
  end

  def self.show(color=:light_yellow)
    "$ ".color(color)
  end

  def show(color=:light_yellow)
    "$ ".color(color)
  end
end
