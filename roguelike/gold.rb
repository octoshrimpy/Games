class Gold < Item
  attr_accessor :value, :x, :y, :coords

  def initialize(attributes)
    @x = attributes[:x]
    @y = attributes[:y]
    @value = attributes[:value]
    $items[Player.depth] ||= []
    $items[Player.depth] << self
  end

  def destroy
    $items[Player.depth].delete(self)
  end

  def self.count
    all.length
  end

  def self.all
    $items[Player.depth]
  end

  def coords
    {x: @x, y: @y}
  end

  def self.show(color=:light_yellow)
    "* ".color(color)
  end
end
