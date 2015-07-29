START = 'S'
FINISH = 'F'
WALL = 'X'
SPACE = '-'
UP = 'N'
DOWN = 'S'
LEFT = 'W'
RIGHT = 'E'
@map = ''

def solve(map)
  @map = Marshal.load(Marshal.dump(map))

  unless map_valid?
    puts "\e[31mMap is invalid.\e[0m"
    return
  end

  directions = ''
  start_coords = find('S').first
  finish_coords = find('F').first
  fx, fy = finish_coords
  sx, sy = start_coords
  @height = @map.length
  @width = @map.first.length

  solved = false
  distance = 0
  distance_map = map.clone
  distance_map[fy][fx] = 0


  until solved
    nexts = find_possible_nexts(find(distance, distance_map), distance_map)
    if nexts.include? start_coords
      solved = true
      solution, coords = find_directions(distance_map, distance, start_coords)
      solution = solution.join
      coords.each do |coord|
        x, y = coord
        @map[y][x] = "\e[32m#{@map[y][x]}\e[0m"
      end
    else
      if nexts.length == 0
        solved = true
        solution = "\e[31mThere is no Solution.\e[0m"
      end
    end
    distance += 1
    nexts.each do |possible|
      x, y = possible
      distance_map[y][x] = distance
    end
  end

  @map.each {|row| puts row.join(' ')}

  puts solution
end

def find_directions(map, distance, start_coords)
  directions = []
  next_coord = start_coords
  coords = [next_coord]
  until distance < 0
    next_coord, direction = lowest(next_coord, map)

    coords << next_coord
    directions << direction
    distance -= 1
  end
  [directions, coords]
end

def lowest(coord, map)
  x, y = coord
  max_distance = (@height * @width)**2
  distance = (@height * @width)**2
  direction = 'x'
  if map[y+1] && (map[y+1][x].is_a?(Integer) ? map[y+1][x] : max_distance) < distance
    low = [x, y+1]
    direction = DOWN
    distance = map[y+1][x].to_i
  end
  if map[y-1] && (map[y-1][x].is_a?(Integer) ? map[y-1][x] : max_distance) < distance && y > 0
    low = [x, y-1]
    direction = UP
    distance = map[y-1][x].to_i
  end
  if map[y] && (map[y][x+1].is_a?(Integer) ? map[y][x+1] : max_distance) < distance
    low = [x+1, y]
    direction = RIGHT
    distance = map[y][x+1].to_i
  end
  if map[y] && (map[y][x-1].is_a?(Integer) ? map[y][x-1] : max_distance) < distance && x > 0
    low = [x-1, y]
    direction = LEFT
    distance = map[y][x-1].to_i
  end
  [low, direction]
end

def find_possible_nexts(coords, map)
  nexts = []
  coords.each do |coord|
    x, y = coord
    nexts << [x+1, y] if map[y] && (map[y][x+1] == SPACE || map[y][x+1] == START)
    nexts << [x-1, y] if map[y] && (map[y][x-1] == SPACE || map[y][x-1] == START) if x > 0
    nexts << [x, y+1] if map[y+1] && (map[y+1][x] == SPACE || map[y+1][x] == START)
    nexts << [x, y-1] if map[y-1] && (map[y-1][x] == SPACE || map[y-1][x] == START) if y > 0
  end
  nexts
end

def find(str, map=@map)
  coords = []
  map.each_with_index do |row, y|
    row.each_with_index do |col, x|
      if map[y][x] == str
        coords << [x, y]
      end
    end
  end
  coords
end

def at(coord)
  x, y = coord
  return nil unless @map[y] && @map[y][x]
  @map[y][x]
end

def map_valid?
  @map.flatten.include?(START) &&
    @map.flatten.include?(FINISH) &&
    @map.map {|row| row.length}.uniq.length == 1
end


map = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
---------X-----------------X--------------X--X
X--XXXX--X--XXXXXXXXXXXXX--X--XXXX--XXXX--X--X
X--X-----X--X--------X--X--X-----X--X--X--X--X
X--XXXXXXX--X--XXXX--X--X--XXXXXXX--X--X--X--X
X--X-----X--X--X-----X--X-----------X--X-----X
X--X--X--X--X--X--XXXX--XXXXXXXXXX--X--XXXX--X
X-----X-----X--X--X--X--------------X--------X
XXXXXXXXXXXXX--X--X--XXXX--X--XXXXXXXXXXXXX--X
X-----------X--X-----X-----X-----X-----X-----X
X--XXXXXXX--X--XXXX--XXXX--XXXX--XXXX--X--XXXX
X--X-----X--X--X--X--------X--X--------X-----X
X--X--X--XXXX--X--XXXXXXX--X--X--XXXXXXXXXX--X
X-----X--------X-XS--X-----X-----X-----------X
XXXX--XXXXXXX--X--XX-X--XXXXXXXXXX--XXXXXXXXXX
X--X-----X-----X-----X-----------X-----X-----X
X--XXXX--X--XXXX--XXXXXXXXXXXXXXXXXXX--X--X--X
X--------X-----X--X-----X-----------X-----X--X
XXXXXXXXXX--XXXX--XXXX--X--XXXXXXX--XXXXXXX--X
X--------X--X--------X--X--------X--X--------X
X--XXXX--X--X--XXXX--X--XXXXXXXXXX--X--XXXX--X
X-----X-----X--X-----X-----X--------X--X-----X
XXXX--XXXXXXX--XXXXXXXXXX--X--XXXXXXX--X--XXXX
X-----X-----X-----X-----X--------X-----X--X--X
X--XXXX--XXXXXXX--X--X--XXXX--X--XXXX--X--X--X
X--X--------------X--X-----X--X--------X-----X
X--XXXX--XXXXXXXXXX--XXXX--X--XXXXXXX--XXXXXXX
X--------X-----------X-----X--X-----X--X-----X
XXXXXXXXXX--XXXXXXXXXX--XXXX--XXXX--X--X--X--X
X--------------------X--------------X-----X--F
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX".split("\n").map{|row|row.split('')}
start_time = Time.now.to_f
solve(map)
process_time = Time.now.to_f - start_time
puts "Took #{process_time} seconds"


map = [%w(- - - - -), %w(- X - - -), %w(S X - - -), %w(X F - - -), %w(- - - - -)]
map = "--------------
--XXXXXXXXXX--
--X--------X--
--X--------X--
--X--XXXXX-X--
S-X------X----
--X--X-F-X-X--
--X--XXXXX-X--
--X--------X--
--XXXXXXXXXX--
--------------".split("\n").map{|row|row.split('')}
