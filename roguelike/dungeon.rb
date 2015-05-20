require './walker.rb'
require './arena.rb'


class Dungeon

  def initialize
    @empty_space = '  '
    @solid_wall = ""
    @up_stairs = '< '
    @down_stairs = '> '
  end

  def self.current
    $dungeon[Player.depth]
  end

  def self.at(coord)
    return nil unless current[coord[:y]]
    current[coord[:y]][coord[:x]]
  end

  def build(size)
    arena = Arena.new
    create_dungeon(arena, size)
    arena[0, 0] = @up_stairs
    arena
  end

  def create_dungeon(arena, walk_length, have_stairs = true, walker = Walker.new)

    while(walk_length>0)
      walk_length -=1

      # Cut out a bit of tunnel where I am.
      arena[*walker.position] = @empty_space unless arena[*walker.position] == @down_stairs
      walker.wander

      # Bosh down a room occasionally.
      if(walk_length%80==0)
        create_room(arena, walker)
      end

      # Spawn off a child now and then. Split the remaining walk_length
      # with it. Only one of us gets the stairs though.
      if(walk_length%20==0)
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
    if(have_stairs)
      arena[*(walker.position)] = @down_stairs
    end
  end

  def create_room(arena, walker)
    max = 6
    width = -rand(max)..rand(max)
    height = -rand(max)..rand(max)
    height.each do |y|
      width.each do |x|
        unless arena[x+walker.x, y+walker.y] == @down_stairs
          arena[x+walker.x, y+walker.y] = @empty_space
        end
      end
    end
  end

end
