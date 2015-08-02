class Projectile
  attr_accessor :x, :y, :depth, :destination_x, :destination_y, :item, :power, :source

  def initialize(destination, item, source=Player)
    self.source = source
    self.x ||= source.x
    self.y ||= source.y
    self.depth ||= source.depth
    self.power ||= source.strength
    self.destination_x = destination[:x]
    self.destination_y = destination[:y]
    self.item = item

    $projectiles << self
  end

  def self.all
    $projectiles
  end

  def tick
    line = Math.get_line(x, y, destination_x, destination_y).sort_by do |coord|
      -Math.distance_between(coord, destination)
    end
    distance = line.count
    self.destination = line[power] if distance > power
    next_spot = line[1]
    stop = (!(next_spot) || Dungeon.at(next_spot, depth).is_solid?)
    unless stop
      if next_spot == Player.coords && source != Player
        stop = true
        collided_with = Player
      else
        Creature.on(depth).each do |creature|
          if next_spot == creature.coords
            stop = true
            collided_with = creature
          end
        end
      end
    end
    if stop
      if collided_with
        collided_with.hit(power * item.weight, self)
        self.item.x, self.item.y, self.item.depth = collided_with.x, collided_with.y, depth if self.item
      else
        self.item.x, self.item.y, self.item.depth = x, y, depth if self.item
      end
      $projectiles.delete(self)
    else
      self.coords = next_spot
    end
  end

  def coords; {x: self.x, y: self.y}; end
  def coords=(new_coord); self.x, self.y = new_coord[:x], new_coord[:y]; end
  def destination; {x: destination_x, y: destination_y}; end
  def destination=(new_coord); self.destination_x, self.destination_y = new_coord[:x], new_coord[:y]; end
end
