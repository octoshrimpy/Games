class Creature
  attr_accessor :x, :y, :health, :attack_speed, :run_speed, :name, :strength, :depth,
                :drops ,:destination, :vision, :rarity, :accuracy, :defense

  def initialize(type, color)
    @mask = "#{type} "
    @color = color
    @destination = nil
    @depth = Player.depth
    drops = %w( g b )
    amount = rand(5)
    stats = case type
    when "a"
      {
        health: (3 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        attack_speed: (4 * (1 + @depth * 0.3)).round,
        run_speed: (10 * (1 + @depth * 0.3)).round,
        verbs: %w( bit clawed cut ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Ant"
      }
    when "b"
      {
        health: (2 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        attack_speed: (4 * (1 + @depth * 0.3)).round,
        run_speed: (12 * (1 + @depth * 0.3)).round,
        verbs: %w( bit clawed slammed cut tore\ at shredded),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Bat"
      }
    when "c"
    when "d"
    when "e"
    when "f"
      {
        health: (3 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        attack_speed: (4 * (1 + @depth * 0.3)).round,
        run_speed: (15 * (1 + @depth * 0.3)).round,
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
        health: (3 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        attack_speed: (4 * (1 + @depth * 0.3)).round,
        run_speed: (15 * (1 + @depth * 0.3)).round,
        verbs: %w( bit clawed slammed tore\ at shredded ),
        drops: ["#{drops.sample}#{amount}"],
        name: "Giant Rat"
      }
    when "s"
      {
        health: (2 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (3 * (1 + @depth * 0.3)).round,
        attack_speed: (5 * (1 + @depth * 0.3)).round,
        run_speed: (3 * (1 + @depth * 0.3)).round,
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
        health: (5 * (1 + @depth * 0.3)).round,
        # rarity: ,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (4 * (1 + @depth * 0.3)).round,
        attack_speed: (5 * (1 + @depth * 0.3)).round,
        run_speed: (3 * (1 + @depth * 0.3)).round,
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
    @defense = stats[:defense]
    @vision = stats[:vision]
    @rarity = stats[:rarity]
    @accuracy = stats[:accuracy]
    @strength = stats[:strength]
    @attack_speed = stats[:attack_speed]
    @run_speed = stats[:run_speed]
    @verbs = stats[:verbs]
    @drops = stats[:drops]
    @name = stats[:name]
  end

  def self.count
    $npcs[Player.depth].length
  end

  def self.current
    $npcs[Player.depth]
  end

  def self.on(level)
    $npcs[level]
  end

  def self.all
    $npcs.flatten
  end

  def self.at(coord, depth=Player.depth)
    Creature.on(depth).select { |creature| creature.x == coord[:x] && creature.y == coord[:y] }
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
        spot = drop_locations.sample
        item = case d[0]
        when "g" then Gold.new({value: rand(1..3)})
        when 'b' then Item['Bread Scrap']
        else "o "
        end
        item.x = spot[:x]
        item.y = spot[:y]
        item.depth = self.depth
      end
    end
    $npcs[Player.depth].delete(self)
  end

  def coords
    {x: self.x, y: self.y}
  end

  def hit(raw_damage, source)
    self.hurt(raw_damage - self.defense)
  end
  
  def hurt(damage=1, src="#{color(@name)} received #{damage.round} damage.")
    @health -= damage.round
    Log.add(src)
    self.destroy(src) if @health <= 0
  end

  def color(str)
    str.color(@color)
  end

  def spawn
    coord = Dungeon.find_open_spaces.sample
    @x = coord[:x]
    @y = coord[:y]
    $npcs[Player.depth] ||= []
    $npcs[Player.depth] << self
  end

  def random_open_space
    move_on = false
    until move_on
      coord = random_coord
      move_on = Dungeon.at(coord) == '  ' ? true : false
    end
    coord
  end

  def random_coord
    {x: (@x-10..@x+10).to_a.sample, y: (@y-10..@y+10).to_a.sample}
  end

  def move(type='check')
    @destination = nil if @destination == coords || rand(10) == 0
    if player_in_range?
      @destination = Player.coords.clone
      # TODO Eventually give me scared AI to run away from Player
    else
      @destination ||= random_open_space
    end

    move_to = @destination ? move_to_target : self.coords

    if move_to == Player.coords
      damage = rand(Player.visible ? @accuracy : 4) <= 1 ? 0 : rand(@strength) + 1

      if damage == 0
        Log.add "#{color(@name)} missed you!"
      else
        Player.hurt(damage, "#{color(@name)} #{@verbs.sample} you for #{damage} damage.")
        Player.last_hit_by = color(@name)
      end
    elsif move_to
      @x = move_to[:x]
      @y = move_to[:y]
    end
  end

  def move_to_target
    moves = []
    dist = 100
    possible_moves.each do |move|
      distance_to = Math.distance_between(move, @destination)
      if distance_to < dist
        moves = []
        dist = distance_to
        moves << move
      elsif distance_to == dist
        moves << move
      end
    end
    moves.sample
  end

  def player_in_range?
    return false unless Player.visible
    in_range = Visible.in_range(10, self.coords, Player.coords)
    if in_range && $gamemode == 'sleep'
      $sleep_condition = 'true'
      $message = "I hear a sound nearby."
    end
    in_range
  end

  def possible_moves
    move_to = (-1..1).map do |y|
      (-1..1).map do |x|
        if Dungeon.current[@y + y] && Dungeon.current[@y + y][@x + x]
          unless Dungeon.current[@y + y][@x + x].is_solid? || Creature.current.map {|m|m.coords}.include?({x: @x + x, y: @y + y})
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
        distance = Math.distance_between(spot, Player.coords)
        if distance < shortest_distance
          shortest_distance = distance
          possible = []
        end
        if Math.distance_between(spot, Player.coords) == shortest_distance
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
