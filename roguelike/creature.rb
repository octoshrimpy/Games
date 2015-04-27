class Creature
  attr_accessor :x, :y, :health, :attack_speed, :run_speed, :name, :strength, :drops

  def initialize(type, color)
    @mask = "#{type} "
    @color = color
    level = Player.me.depth
    drops = %w( g )
    amount = rand(5)
    stats = case type
    when "a"
      {
        health: (3 * (1 + level * 0.3)).round,
        strength: (1 * (1 + level * 0.3)).round,
        attack_speed: (4 * (1 + level * 0.3)).round,
        run_speed: (10 * (1 + level * 0.3)).round,
        verbs: %w( bit clawed cut ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Ant"
      }
    when "b"
      {
        health: (2 * (1 + level * 0.3)).round,
        strength: (1 * (1 + level * 0.3)).round,
        attack_speed: (4 * (1 + level * 0.3)).round,
        run_speed: (12 * (1 + level * 0.3)).round,
        verbs: %w( bit clawed slammed cut tore\ at shredded),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Bat"
      }
    when "c"
    when "d"
    when "e"
    when "f"
      {
        health: (3 * (1 + level * 0.3)).round,
        strength: (1 * (1 + level * 0.3)).round,
        attack_speed: (4 * (1 + level * 0.3)).round,
        run_speed: (15 * (1 + level * 0.3)).round,
        verbs: %w( struck bit clawed kicked slammed tore\ at shredded ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Possessed Fox"
      }
    when "g"
    when "h"
    when "i"
    when "j"
    when "k"
    when "l"
    when "m"
    when "n"
    when "o"
    when "p"
    when "q"
    when "r"
      {
        health: (3 * (1 + level * 0.3)).round,
        strength: (1 * (1 + level * 0.3)).round,
        attack_speed: (4 * (1 + level * 0.3)).round,
        run_speed: (15 * (1 + level * 0.3)).round,
        verbs: %w( bit clawed slammed tore\ at shredded ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Rat"
      }
    when "s"
      {
        health: (2 * (1 + level * 0.3)).round,
        strength: (3 * (1 + level * 0.3)).round,
        attack_speed: (5 * (1 + level * 0.3)).round,
        run_speed: (3 * (1 + level * 0.3)).round,
        verbs: %w( bit struck whipped choked ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Snake"
      }
    when "t"
    when "u"
    when "v"
    when "w"
    when "x"
      {
        health: (5 * (1 + level * 0.3)).round,
        strength: (4 * (1 + level * 0.3)).round,
        attack_speed: (5 * (1 + level * 0.3)).round,
        run_speed: (3 * (1 + level * 0.3)).round,
        verbs: %w( struck bit clawed kicked slammed slapped whipped pummeled elbowed kneed cut choked tore\ at shredded slugged shot ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Unknown Beast"
      }
    when "y"
    when "z"
    when "A"
    when "B"
    when "C"
    when "D"
    when "E"
    when "F"
    when "G"
    when "H"
    when "I"
    when "J"
    when "K"
    when "L"
    when "M"
    when "N"
    when "O"
    when "P"
    when "Q"
    when "R"
    when "S"
    when "T"
    when "U"
    when "V"
    when "W"
    when "X"
    when "Y"
    when "Z"
    end
    @health = stats[:health]
    @strength = stats[:strength]
    @attack_speed = stats[:attack_speed]
    @run_speed = stats[:run_speed]
    @verbs = stats[:verbs]
    @drops = stats[:drops]
    @name = stats[:name]
  end

  def self.count
    $npcs[Player.me.depth].length
  end

  def self.all
    $npcs[Player.me.depth]
  end

  def destroy(src)
    Log.add("#{color(@name)} was beaten to death.")
    drop_locations = (-1..1).map do |y|
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
    self.drops.each do |d|
      d[1].to_i.times do
        drop_item = case d[0]
        when "g" then "* "
        else "o "
        end
        spot = drop_locations.sample
        Dungeon.current[spot[:y]][spot[:x]] = drop_item
      end
    end
    $npcs[Player.me.depth].delete(self)
  end

  def coords
    {x: self.x, y: self.y}
  end

  def hurt(damage=1, src="#{color(@name)} received some damage.")
    @health -= damage
    Log.add(src)
    self.destroy(src) if @health <= 0
  end

  def color(str)
    "#{str.color(@color)}\e[37m"
  end

  def spawn
    coord = Dungeon.current.search_for("  ").sample
    @x = coord[:x]
    @y = coord[:y]
    $npcs[Player.me.depth] ||= []
    $npcs[Player.me.depth] << self
  end

  def move(type="check")
    # Remember the last place the player was seen, and go there.
    # If player in vision, set 'target' to player. Then 'chase' target.
    # Once target is set, target stays until player is seen again- which changes target to player
    # Or once the target is the current spot, then switch target back to nil, which goes back to nil.
    move_to = case type
    when "check"
      if Visible.in_range(10, self.coords, Player.me.coords)
        charge.sample
      else
        wander.sample
      end
    when "wander" then wander.sample
    when "charge" then charge.sample
    when "retreat" then retreat.sample
    end
    if move_to && move_to == Player.me.coords
      damage = rand(10) == 0 ? 0 : rand(@strength) + 1
      if damage == 0
        Log.add "#{color(@name)} missed you!"
      else
        Player.me.hurt(damage, "#{color(@name)} #{@verbs.sample} you for #{damage} damage.")
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
          unless Dungeon.current[@y + y][@x + x].is_solid? || Creature.all.map {|m|m.coords}.include?({x: @x + x, y: @y + y})
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
    shortest_distance = 100
    possible = []
    if move_to
      move_to.each do |spot|
        distance = Visible.distance_to(spot, Player.me.coords)
        if distance < shortest_distance
          shortest_distance = distance
          possible = []
        end
        if Visible.distance_to(spot, Player.me.coords) == shortest_distance
          possible << spot
        end
      end
    end
    possible
  end

  def retreat
  end

  def show
    "\e[31m#{@mask}\e[0m"
  end
end
