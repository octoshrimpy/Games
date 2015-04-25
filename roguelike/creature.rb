class Creature
  attr_accessor :x, :y, :health, :speed, :name

  def initialize(options={})
    @health = 5
    @speed = 10
    @mask = "x "
    @color = "\e[31m"
    @name = "Creature"
    options.each do |option|
      case option.key
      when health then @health = option.value
      end
    end
  end

  def destroy
    $npcs[Player.me.depth].delete(self)
    $log << "#{$tick}: " +  "#{color(@name)} was stomped to death."
  end

  def coords
    {x: self.x, y: self.y}
  end

  def hurt(damage=1, src="#{color(@name)} received some damage.")
    @health -= damage
    $log << "#{$tick}: " +  src
    self.destroy if @health <= 0
  end

  def color(str)
    "#{@color}#{str}\e[37m"
  end

  def spawn
    coord = $dungeon[Player.me.depth].search_for("  ").sample
    # $dungeon[Player.me.depth][coord[:y]][coord[:x]] = self.show
    @x = coord[:x]
    @y = coord[:y]
    $npcs[Player.me.depth] ||= []
    $npcs[Player.me.depth] << self
  end

  def move(type)
    case type
    when "wander" then wander
    when "charge" then charge
    when "retreat" then retreat
    end
  end

  def wander
    move_to = (-1..1).map do |y|
      (-1..1).map do |x|
        if $dungeon[Player.me.depth][@y + y] && $dungeon[Player.me.depth][@y + y][@x + x]
          unless $dungeon[Player.me.depth][@y + y][@x + x].is_solid?
            {x: @x + x, y: @y + y}
          else
            nil
          end
        else
          nil
        end
      end
    end.flatten.compact.sample
    return false unless move_to
    if move_to == Player.me.coords
      damage = rand(10)
      verb = %w( struck bit clawed kicked slammed slapped whipped pummeled elbowed kneed cut choked tore shredded slugged shot ).sample
      Player.me.hurt(damage, "#{color(@name)} #{verb} you for #{damage} damage.")
    else
      @x = move_to[:x]
      @y = move_to[:y]
    end
    true
  end

  def charge
  end

  def retreat
  end

  def show
    "\e[31m#{@mask}\e[0m"
  end
end
