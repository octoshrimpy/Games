class Gold
  attr_accessor :value, :x, :y, :coords, :depth

  def initialize(attributes)
    @x = attributes[:x]
    @y = attributes[:y]
    @value = attributes[:value]
    @depth = attributes[:depth] || Player.depth
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
    $drops[Player.depth].select {|g|g.is_a?(Gold)}
  end

  def coords
    {x: @x, y: @y, depth: @depth}
  end

  def drop(coords)
    self.x = coords[:x]
    self.y = coords[:y]
    self.depth = coords[:depth]
    $screen_shot_objects << {instance: self, x: self.x, y: self.y, depth: self.depth}
    self
  end

  def pickup
    $screen_shot_objects.delete({instance: self, x: self.x, y: self.y, depth: self.depth})
    self.destroy
  end

  def stack_size; 1; end

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
