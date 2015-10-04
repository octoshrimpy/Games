class Projectile
  attr_accessor :x, :y, :depth, :destination_x, :destination_y, :item, :power, :source, :speed, :dob

  def initialize(destination, item, source, options={})
    self.dob = $time
    self.speed = options[:speed] || 80
    self.source = source
    self.x ||= source.x
    self.y ||= source.y
    self.depth ||= source.depth
    self.destination_x = destination[:x]
    self.destination_y = destination[:y]
    self.item = item
    self.power ||= Math.greater_of((x - destination_x).abs, (y - destination_y).abs)

    $projectiles << self
  end

  def self.all
    $projectiles
  end

  def show
    item ? item.show : 'x'
  end

  def tick
    line = Math.get_line(x, y, destination_x, destination_y).sort_by do |coord|
      -Math.distance_between(coord, destination)
    end
    distance = line.count
    self.destination = line[power] if distance > power

    last_coord = {x: x, y: y}
    unless stop = destination == last_coord
      next_coord = line[1]
      spot = next_coord ? Dungeon.at(next_coord.merge({depth: depth})) : nil
      stop = spot.is_solid? if spot
      if (next_coord == Player.coords.filter(:x, :y) || last_coord == Player.coords.filter(:x, :y)) && source != Player
        stop = true
        collided_with = Player
      else
        Creature.on(depth).each do |creature|
          if (next_coord == creature.coords.filter(:x, :y) || last_coord == creature.coords.filter(:x, :y)) && source != creature
            stop = true
            collided_with = creature
          end
        end
      end
    end
    if stop
      collided_with_item = collided_with || spot
      if collided_with
        collided_with.hit(item.collided_damage(power), self) if item.collided_damage(power) > 0
        self.item.x, self.item.y, self.item.depth = collided_with.x, collided_with.y, collided_with.depth
      else
        self.item.x, self.item.y, self.item.depth = x, y, depth if self.item
      end
      item.collide(collided_with_item)
      $projectiles.delete(self)
    else
      self.coords = next_coord
    end
  end

  def coords; {x: self.x, y: self.y}; end
  def coords=(new_coord); self.x, self.y = new_coord[:x], new_coord[:y]; end
  def destination; {x: destination_x, y: destination_y}; end
  def destination=(new_coord); self.destination_x, self.destination_y = new_coord[:x], new_coord[:y]; end
end
