class Creature
  attr_accessor :x, :y, :health, :run_speed, :name, :strength, :depth, :id,
                :drops ,:destination, :vision, :accuracy, :defense, :verbs,
                :tick_script, :attracted_to, :sense_range, :can_move, :birth,
                :is_boss, :affected_by

  def initialize(type, creature_color=nil)
    @mask = "#{type} "
    @is_boss = false
    @affected_by = [] # Should be hash {"conditional string" => "effect (speed / 2)"}
    @creature_color = creature_color
    @can_move = true
    @destination = nil
    @depth = Player.depth
    @birth = $time + 1
    @id = $ids; $ids += 1
    stats = case type
    when "a"
      {
        health: (1 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (2 + (@depth * 0.1)).round,
        run_speed: 6,
        verbs: %w( bit clawed cut ),
        drops: (%w( bread bread bread2 gold )*5).sample(rand(5)),
        name: "Giant Ant",
        attracted_to: ['Player']
      }
    when "b"
      {
        health: (1 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 20,
        vision: 15,
        strength: (1 + (@depth * 0.1)).round,
        run_speed: 11,
        verbs: %w( bit clawed slammed cut tore\ at shredded),
        drops: (%w( bread bread bread bread gold )*3).sample(rand(3)),
        name: "Giant Bat",
        attracted_to: ['Player']
      }
    when "c"
    when "d"
      {
        health: (10 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (10 + (@depth * 0.1)).round,
        run_speed: 8,
        verbs: %w( bit clawed slammed cut tore\ at shredded),
        drops: (%w( bread2 bread2 bread2 bread2 gold )*3).sample(rand(3)),
        name: "Drake",
        attracted_to: ['Player']
      }
    when "e"
    when "f"
      {
        health: (2 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (2 + (@depth * 0.1)).round,
        run_speed: 8,
        verbs: %w( struck bit clawed kicked slammed tore\ at shredded ),
        drops: (%w( bread bread bread2 gold gold )*5).sample(rand(5)),
        name: "Possessed Fox",
        attracted_to: ['Player']
      }
    when "g"
    when "h"
    when "i"
    when "j"
    when "k"
      {
        health: (4 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (6 + (@depth * 0.1)).round,
        run_speed: 8,
        verbs: %w( haunted clawed tore\ at shredded ),
        drops: (%w( bread bread bread2 gold gold )*5).sample(rand(5)),
        name: "Kobold",
        attracted_to: ['Player']
      }
    when "l"
    when "m"
      {
        health: (1 + (@depth * 0.5)).round,
        defense: 0,
        accuracy: 90,
        vision: 2,
        strength: (1 + (@depth * 0.2)).round,
        run_speed: 4,
        color: :light_green,
        verbs: %w( slimed ),
        drops: %w( slime ),
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
        health: (2 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 60,
        vision: 10,
        strength: (2 + (@depth * 0.1)).round,
        run_speed: 4,
        verbs: %w( bit clawed slammed tore\ at shredded ),
        drops: (%w( bread bread bread2 bread2 gold )*5).sample(rand(5)),
        name: "Giant Rat",
        attracted_to: ['Player']
      }
    when "s"
      {
        health: (2 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (4 + (@depth * 0.1)).round,
        run_speed: 3,
        verbs: %w( bit struck whipped choked ),
        drops: (%w( bread bread bread gold )*5).sample(rand(5)),
        name: "Snake",
        attracted_to: ['Player']
      }
    when "t"
      {
        health: (2 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 8,
        strength: (4 + (@depth * 0.1)).round,
        run_speed: 6,
        verbs: %w( whacked struck beat slammed ),
        drops: ['cursedbone'] + %w( gold gold  ),
        name: "Skeleton",
        attracted_to: ['Player']
      }
    when "u"
    when "v"
    when "w"
    when "x"
      {
        health: (5 + (@depth * 0.3)).round,
        defense: 0,
        accuracy: 90,
        vision: 10,
        strength: (4 + (@depth * 0.1)).round,
        run_speed: 4,
        verbs: %w( struck bit clawed kicked slammed slapped whipped pummeled elbowed kneed cut choked tore\ at shredded slugged shot ),
        drops: (%w( bread gold )*5).sample(rand(5)),
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
    @creature_color ||= (stats[:color] || :red)
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
    Creature.on_board.select { |creature| creature.name == name }
  end

  def self.count
    $npcs[Player.depth].length
  end

  def self.on_board
    $npcs[Player.depth]
  end

  def self.on(level)
    $npcs[level]
  end

  def self.all
    $npcs.flatten
  end

  def self.at(coord)
    Creature.on(coord[:depth]).select { |creature| creature.x == coord[:x] && creature.y == coord[:y] }
  end

  def self.creatures_on_level(level)
    {
      '1' => %w( a a b b b f f f f r r r r r m ),
      '2' => %w( a b b f r r r s ),
      '3' => %w( a b b f r r s m ),
      '4' => %w( a b b f r s ),
      '5' => %w( a b b r s t ),
      '6' => %w( a b b s t ),
      '7' => %w( a b b s m t ),
      '8' => %w( b b s t ),
      '9' => %w( b b s t ),
      '10' => %w( m ),
      '11' => %w( b b m k t ),
      '12' => %w( b b k t ),
      '13' => %w( b b m k t ),
      '14' => %w( b b k t ),
      '15' => %w( b b k t d ),
      '16' => %w( b b k t d ),
      '17' => %w( b b m k t d ),
      '18' => %w( b k t d ),
      '19' => %w( b k t d ),
      '20' => %w( ),
      '21' => %w( m k t d ),
      '22' => %w( k t d ),
      '23' => %w( m k t d ),
      '24' => %w( k t d ),
      '25' => %w( k t d ),
      '26' => %w( k t d ),
      '27' => %w( m k t d ),
      '28' => %w( k t d ),
      '29' => %w( k t d ),
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
            {x: @x + x, y: @y + y, depth: @depth}
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
      depth = Player.depth
      low_val = (depth / 5).ceil + 1
      high_val = (depth / 4).ceil + 1
      gold_value = rand(low_val..high_val)
      item = case d
      when "gold" then Gold.new({value: gold_value.ceil})
      when 'bread' then Item['Bread Scrap']
      when 'slime' then 'Slime Ball'
      when 'bread2' then Item['Bread Chunk']
      when 'cursedbone' then Item['Cursed Bone']
      else "o "
      end
      if item == 'Slime Ball'
        self.strength.times do
          Item[item].drop(drop_locations.sample)
        end
      else
        item.drop(spot)
      end
    end
    Dungeon.current[self.y][self.x] = "> " if is_boss
    $npcs[Player.depth].delete(self)
  end

  def coords
    {x: self.x, y: self.y, depth: self.depth}
  end

  def hit(raw_damage, type_of_damage)
    damage = case type_of_damage
    when 'physical' then raw_damage - self.defense
    when 'magic' then raw_damage - self.magic_resist
    else raw_damage
    end
    self.hurt(damage, type_of_damage)
  end

  def hurt(damage=1, src="")
    src += ' ' if src.length > 0
    if damage <= 0
      Log.add("#{Math.greater_of(0, damage.round)} #{src}damage was dealt to #{colored_name}.")
    else
      @health -= damage.round
      Log.add("#{damage.round} #{src}damage was dealt to #{colored_name}.")
      self.destroy(src) if @health <= 0
    end
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
    self
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
    {x: (@x-10..@x+10).to_a.sample, y: (@y-10..@y+10).to_a.sample, depth: depth}
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
      if Item.reference(attraction)
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
        Player.hit(damage, 'physical')
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
    if in_range && ($gamemode == 'sleep' ||  $gamemode == 'auto-pilot')
      $auto_pilot_condition = 'true' # Cancel auto-pilot
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
          unless Dungeon.current[@y + y][@x + x].is_solid? || Creature.on_board.map {|m|m.coords}.include?({x: @x + x, y: @y + y, depth: depth})
            {x: @x + x, y: @y + y, depth: depth}
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
