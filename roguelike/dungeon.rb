require './walker.rb'
require './arena.rb'
require './automata_cave.rb'

class Dungeon

  def self.presets(preset)
    case preset
    when 'maze' then {distance_between_rooms: 100, split_every: 50, room_size: 6, tunnel_thickness: 3, tunnel_density: 90}
    when 'cavernous' then {distance_between_rooms: 100, split_every: 20, room_size: 6, tunnel_thickness: 3, tunnel_density: 90}
    when 'tunnels' then {distance_between_rooms: 50, split_every: 20, room_size: 2, tunnel_thickness: 2, tunnel_density: 30}
    when 'open' then {distance_between_rooms: 50, split_every: 20, room_size: 2, tunnel_thickness: 10, tunnel_density: 80}
    when 'outside' then {distance_between_rooms: 10, split_every: 10, room_size: 10, tunnel_thickness: 10, tunnel_density: 100}
    else {distance_between_rooms: 100, split_every: 20, room_size: 6, tunnel_thickness: 1, tunnel_density: 100}
    end
  end

  def initialize(preset='maze')
    options = Dungeon.presets(preset)
    $preset = preset
    @empty_space = '  '
    @solid_wall = ""
    @up_stairs = '< '
    @down_stairs = '> '
    @distance_between_rooms = options[:distance_between_rooms] || 50
    @split_every = options[:split_every] || 20
    @room_size = options[:room_size] || 2
    @tunnel_thickness = options[:tunnel_thickness] || 1
    @tunnel_density = options[:tunnel_density] || 100
  end

  def self.current
    $dungeon[Player.depth]
  end

  def self.at_level(depth)
    $dungeon[depth]
  end

  def self.at(coord)
    return nil unless at_level(coord[:depth])[coord[:y]]
    at_level(coord[:depth])[coord[:y]][coord[:x]]
  end

  def self.find_open_spaces(allow_landing_items=true)
    if allow_landing_items
      (current.search_for("  ").each { |xy_coord| xy_coord[:depth] = Player.depth })
    else
      (current.search_for("  ").each { |xy_coord| xy_coord[:depth] = Player.depth })  - (Item.on_board.map(&:coords) + Gold.on_board.map(&:coords) + Creature.on_board.map(&:coords) + [Player.coords])
    end
  end

  def standard_build(size, depth=Player.depth)
    srand($seed + depth)

    arena = Arena.new
    create_dungeon(arena, size)
    arena[0, 0] = @up_stairs

    arena.to_array
  end

  def open_cave_build(size, depth=Player.depth)
    srand($seed + depth)
    AutomataCave.new(size, size, 53).generate!
  end

  def create_dungeon(arena, walk_length, have_stairs = true, walker = Walker.new)

    while walk_length > 0
      walk_length -= 1

      thickness = ((@tunnel_thickness - 1).to_f/2).round.to_i
      width = (-thickness..thickness - (@tunnel_thickness.even? ? 1 : 0))
      height = (-thickness..thickness - (@tunnel_thickness.even? ? 1 : 0))
      height.each do |y|
        width.each do |x|
          unless arena[x+walker.x, y+walker.y] == @down_stairs
            if (x == 0 && y == 0) || (rand(100) >= @tunnel_density)
              arena[x+walker.x, y+walker.y] = @empty_space
            end
          end
        end
      end
      walker.wander

      if walk_length % @distance_between_rooms == 0
        create_room(arena, walker)
      end

      # Spawn off a child now and then. Split the remaining walk_length
      # with it. Only one of us gets the stairs though.
      if walk_length % @split_every == 0
        child_walk_length = rand(walk_length)
        walk_length -= child_walk_length
        if child_walk_length > walk_length
          create_dungeon(arena, child_walk_length, have_stairs, walker.create_child)
          have_stairs = false
        else
          create_dungeon(arena, child_walk_length, false, walker.create_child)
        end
      end
    end

    # Put in the down stairs, if I have them.
    if have_stairs
      arena[*(walker.position)] = @down_stairs
    end
  end

  def create_room(arena, walker)
    width = -rand(@room_size)..rand(@room_size)
    height = -rand(@room_size)..rand(@room_size)
    height.each do |y|
      width.each do |x|
        unless arena[x+walker.x, y+walker.y] == @down_stairs
          arena[x+walker.x, y+walker.y] = @empty_space
        end
      end
    end
  end

end
