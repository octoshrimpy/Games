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
    Log.add("#{color(@name)} was stomped to death.")
  end

  def coords
    {x: self.x, y: self.y}
  end

  def hurt(damage=1, src="#{color(@name)} received some damage.")
    @health -= damage
    Log.add(src)
    self.destroy if @health <= 0
  end

  def color(str)
    "#{@color}#{str}\e[37m"
  end

  def spawn
    coord = Dungeon.current.search_for("  ").sample
    # Dungeon.current[coord[:y]][coord[:x]] = self.show
    @x = coord[:x]
    @y = coord[:y]
    $npcs[Player.me.depth] ||= []
    $npcs[Player.me.depth] << self
  end

  def move(type)
    move_to = case type
    when "wander" then wander.sample
    when "charge" then charge
    when "retreat" then retreat
    end
    if move_to && move_to == Player.me.coords
      damage = rand(10) == 0 ? 0 : rand(2) + 1
      if damage == 0
        Log.add "#{color(@name)} missed you!"
      else
        verb = %w( struck bit clawed kicked slammed slapped whipped pummeled elbowed kneed cut choked tore shredded slugged shot ).sample
        Player.me.hurt(damage, "#{color(@name)} #{verb} you for #{damage} damage.")
      end
    else
      @x = move_to[:x]
      @y = move_to[:y]
    end
  end

  def wander
    move_to = (-1..1).map do |y|
      (-1..1).map do |x|
        if Dungeon.current[@y + y] && Dungeon.current[@y + y][@x + x]
          unless Dungeon.current[@y + y][@x + x].is_solid?
            {x: @x + x, y: @y + y}
          else
            nil
          end
        else
          nil
        end
      end
    end.flatten.compact
    move_to
  end

  def charge
    move_to = wander
    if move_to

    end
    move_to
  end

  def retreat
  end

  def show
    "\e[31m#{@mask}\e[0m"
  end
end
