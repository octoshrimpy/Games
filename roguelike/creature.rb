class Creature
  attr_accessor :x, :y, :health, :run_speed, :name, :strength, :depth, :id,
                :drops ,:destination, :vision, :accuracy, :defense, :verbs,
                :tick_script, :attracted_to, :sense_range, :can_move

  def initialize(type, creature_color)
    @mask = "#{type} "
    @creature_color = creature_color
    @can_move = true
    @destination = nil
    @depth = Player.depth
    @id = $ids; $ids += 1
    stats = case type
    when "a"
      {
        health: (3 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        run_speed: 6,
        verbs: %w( bit clawed cut ),
        drops: (%w( b b bb g )*5).sample(rand(5)),
        name: "Giant Ant",
        attracted_to: ['Player']
      }
    when "b"
      {
        health: (2 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 20,
        vision: 15,
        strength: (1 * (1 + @depth * 0.3)).round,
        run_speed: 11,
        verbs: %w( bit clawed slammed cut tore\ at shredded),
        drops: (%w( b b b b g )*3).sample(rand(3)),
        name: "Giant Bat",
        attracted_to: ['Player']
      }
    when "c"
    when "d"
    when "e"
    when "f"
      {
        health: (3 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        run_speed: 7,
        verbs: %w( struck bit clawed kicked slammed tore\ at shredded ),
        drops: (%w( b b bb g g )*5).sample(rand(5)),
        name: "Possessed Fox",
        attracted_to: ['Player']
      }
    when "g"
    when "h"
    when "i"
    when "j"
    when "k"
    when "l"
    when "m"
      {
        health: (1 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 2,
        strength: (1 * (1 + @depth * 0.3)).round,
        run_speed: 4,
        color: :light_green,
        verbs: %w( slimed ),
        drops: (%w( i i i i i i g )*5).sample(rand(5)),
        attracted_to: ['Slime Ball', 'Player'],
        sense_range: {'Slime Ball' => 7},
        tick_script: 'eval(Evals.try_to_split_slime); eval(Evals.pickup_slime)',
        name: "Slime"
      }
    when "n"
    when "o"
    when "p"
    when "q"
    when "r"
      {
        health: (3 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 60,
        vision: 10,
        strength: (1 * (1 + @depth * 0.3)).round,
        run_speed: 4,
        verbs: %w( bit clawed slammed tore\ at shredded ),
        drops: (%w( b b bb bb g )*5).sample(rand(5)),
        name: "Giant Rat",
        attracted_to: ['Player']
      }
    when "s"
      {
        health: (2 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (3 * (1 + @depth * 0.3)).round,
        run_speed: 3,
        verbs: %w( bit struck whipped choked ),
        drops: (%w( b b b g )*5).sample(rand(5)),
        name: "Snake",
        attracted_to: ['Player']
      }
    when "t"
    when "u"
    when "v"
    when "w"
    when "x"
      {
        health: (5 * (1 + @depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (4 * (1 + @depth * 0.3)).round,
        run_speed: 4,
        verbs: %w( struck bit clawed kicked slammed slapped whipped pummeled elbowed kneed cut choked tore\ at shredded slugged shot ),
        drops: (%w( b g )*5).sample(rand(5)),
        name: "Unknown Beast",
        attracted_to: ['Player']
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
    @accuracy = stats[:accuracy]
    @strength = stats[:strength]
    @creature_color = stats[:color] if stats[:color]
    @tick_script = stats[:tick_script] if stats[:tick_script]
    @run_speed = stats[:run_speed]
    @verbs = stats[:verbs]
    @drops = stats[:drops]
    @attracted_to = stats[:attracted_to]
    @sense_range = stats[:sense_range]
    @name = stats[:name]
  end

  def self.find(search_id)
    Creature.all.compact.select { |monster| monster.id == search_id }.first
  end

  def self.[](name)
    Creature.current.select { |creature| creature.name == name }
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

  def self.creatures_on_level(level)
    {
      '1' => %w( a a b b b f f f f r r r r r m ),
      '2' => %w( a b b f r r r s ),
      '3' => %w( a b b f r r s m ),
      '4' => %w( a b b f r s ),
      '5' => %w( a b b r s ),
      '6' => %w( a b b s ),
      '7' => %w( a b b s m ),
      '8' => %w( b b s ),
      '9' => %w( b b s ),
      '10' => %w( b b s ),
      '11' => %w( b b m ),
      '12' => %w( b b ),
      '13' => %w( b b m ),
      '14' => %w( b b ),
      '15' => %w( b b ),
      '16' => %w( b b ),
      '17' => %w( b b m ),
      '18' => %w( b ),
      '19' => %w( b ),
      '20' => %w( b ),
      '21' => %w( m ),
      '22' => %w(),
      '23' => %w( m ),
      '24' => %w(),
      '25' => %w(),
      '26' => %w(),
      '27' => %w( m ),
      '28' => %w(),
      '29' => %w(),
      '30' => %w(),
      '31' => %w( m ),
      '32' => %w(),
      '33' => %w( m ),
      '34' => %w(),
      '35' => %w(),
      '36' => %w(),
      '37' => %w( m ),
      '38' => %w(),
      '39' => %w(),
      '40' => %w(),
      '41' => %w( m ),
      '42' => %w(),
      '43' => %w( m ),
      '44' => %w(),
      '45' => %w(),
      '46' => %w(),
      '47' => %w( m ),
      '48' => %w(),
      '49' => %w(),
      '50' => %w(),
      '51' => %w( m ),
      '52' => %w(),
      '53' => %w( m ),
      '54' => %w(),
      '55' => %w(),
      '56' => %w(),
      '57' => %w( m ),
      '58' => %w(),
      '59' => %w(),
      '60' => %w(),
      '61' => %w( m ),
      '62' => %w(),
      '63' => %w( m ),
      '64' => %w(),
      '65' => %w(),
      '66' => %w(),
      '67' => %w( m ),
      '68' => %w(),
      '69' => %w(),
      '70' => %w(),
      '71' => %w( m ),
      '72' => %w(),
      '73' => %w( m ),
      '74' => %w(),
      '75' => %w(),
      '76' => %w(),
      '77' => %w( m ),
      '78' => %w(),
      '79' => %w(),
      '80' => %w(),
      '81' => %w( m ),
      '82' => %w(),
      '83' => %w( m ),
      '84' => %w(),
      '85' => %w(),
      '86' => %w(),
      '87' => %w( m ),
      '88' => %w(),
      '89' => %w(),
      '90' => %w(),
      '91' => %w( m ),
      '92' => %w(),
      '93' => %w( m ),
      '94' => %w(),
      '95' => %w(),
      '96' => %w(),
      '97' => %w( m ),
      '98' => %w(),
      '99' => %w(),
      '100' => %w()
    }[level.to_s]
  end

  def destroy(src)
    Log.add("#{colored_name} died.")
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
      spot = drop_locations.sample
      item = case d
      when "g" then Gold.new({value: rand(Player.depth..(Player.depth * 1.6).round)})
      when 'b' then Item['Bread Scrap']
      when 'i' then Item['Slime Ball']
      when 'bb' then Item['Bread Chunk']
      else "o "
      end
      item.x = spot[:x]
      item.y = spot[:y]
      item.depth = self.depth
    end
    $npcs[Player.depth].delete(self)
  end

  def coords
    {x: self.x, y: self.y}
  end

  def hit(raw_damage, source)
    self.hurt(raw_damage - self.defense)
  end

  def hurt(damage=1, src="")
    @health -= damage.round
    src += ' ' if src.length > 0
    Log.add("#{damage.round} #{src}damage was dealt to #{colored_name}.")
    self.destroy(src) if @health <= 0
  end

  def colored_name(str=self.name)
    str.color(@creature_color)
  end

  def spawn(coord=[])
    if coord.empty?
      coord = Dungeon.find_open_spaces.sample
      until Math.distance_between(coord, Player.coords) > 10
        coord = Dungeon.find_open_spaces.sample
      end
    end
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

  def tick(type='check')
    @can_move = true

    eval(@tick_script) if @tick_script

    return false unless @can_move

    @destination = nil if @destination == coords || rand(10) == 0
    target = nil
    found_destination = nil
    @attracted_to.each do |attraction|
      next if found_destination
      if attraction == 'Player' && player_in_range?
        found_destination = Player.coords.clone
      end
      if Item[attraction]
        item = find_nearest_item_in_range(attraction)
        found_destination = item.coords if item
      end
    end
    @destination = found_destination if found_destination
    @destination ||= random_open_space

    move_to = @destination ? move_to_target : self.coords

    if move_to == Player.coords
      damage = rand(Player.visible ? @accuracy : 4) <= 1 ? 0 : rand(@strength) + 1

      if damage == 0
        Log.add "#{colored_name} missed you!"
      else
        Player.last_hit_id = @id
        Player.hurt(damage, 'physical')
      end
    elsif move_to
      @x = move_to[:x]
      @y = move_to[:y]
    end
  end

  def find_nearest_item_in_range(name)
    items_by_range = Item.all_by_name(name).group_by { |i| Math.distance_between(i.coords, self.coords) }.reject { |k, v| k.nil? }.sort_by { |k, v| k }.collect { |k, v| v }.flatten
    found_item = nil
    i = 0
    while found_item.nil?
      item = items_by_range[i]
      if item
        is_in_range = Visible.in_range((sense_range[item.name] || self.vision), self.coords, item.coords)
        if is_in_range
          found_item = item
        end
      else
        found_item = false
      end
      i += 1
    end
    found_item
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
    in_range = Visible.in_range(self.vision, self.coords, Player.coords)
    if in_range && $gamemode == 'sleep'
      $sleep_condition = 'true'
      $message = "I hear a sound nearby."
    end
    in_range
  end

  def possible_moves(corners=true)
    move_to = (-1..1).map do |y|
      (-1..1).map do |x|
        if corners == false && ([[1, 1], [-1, 1], [1, -1], [-1, -1]]).include?([x, y])
          nil
        elsif Dungeon.current[@y + y] && Dungeon.current[@y + y][@x + x]
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
    @mask.color(@creature_color)
  end
end
