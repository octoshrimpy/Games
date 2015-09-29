class Cell
  attr_accessor :immediate_neighbor_count, :near_neighbor_count, :filled

  def initialize(percent_alive)
    @alive = rand(100) < percent_alive
    @filled = false
  end

  def tick!(cut_off)
    @alive = !((9 - @immediate_neighbor_count) >= cut_off[0] || (25 - @near_neighbor_count) < cut_off[1])
  end

  def to_i
    @alive ? 1 : 0
  end

end

class AutomataCave
  attr_reader :dungeon

  def initialize(width, height, percent_alive)
    @width, @height = width, height
    @cells = Array.new(height) {Array.new(width) { Cell.new(percent_alive) }}
    @empty_space = '  '
    @solid_wall = "▒ "
    @wall = "# "
    @up_stairs = '< '
    @down_stairs = '> '
  end

  def generate!
    until cell_ratio > 20
      4.times { tick!([5, 2]) }
      3.times { tick!([5, -1]) }
      fill_cave
    end
    to_roguelike_dungeon
    place_stairs!
    @dungeon
  end

  def place_stairs!
    y = @dungeon.size
    x = @dungeon.first.size
    try_x, try_y = rand(x), rand(y)
    cell = ''
    until cell == @empty_space
      try_x, try_y = rand(x), rand(y)
      cell = @dungeon[try_y][try_x]
    end
    @dungeon[try_y][try_x] = @up_stairs
    cell = ''
    until cell == @empty_space
      try_x, try_y = rand(x), rand(y)
      cell = @dungeon[try_y][try_x]
    end
    @dungeon[try_y][try_x] = @down_stairs
  end

  def tick!(cut_off)
    @cells.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        cell.immediate_neighbor_count = live_count(y, x, 1)
        cell.near_neighbor_count = live_count(y, x, 2)
      end
    end
    @cells.each { |row| row.each { |cell| cell.tick!(cut_off) } }
  end

  def live_count(y, x, range)
    count = 0
    (-range..range).each do |rx|
      (-range..range).each do |ry|
        next if rx + x >= @width || ry + y >= @height || rx + x < 0 || ry + y < 0
        count += @cells[y + ry][x + rx].to_i
      end
    end
    count
  end

  def fill_cave
    cell_coords = [find_center_cell_coord(5)]
    neighbors_filled = 1
    until neighbors_filled == 0
      neighbors_filled = 0
      cell_coords.each do |cell_coord|
        (-1..1).each do |y|
          (-1..1).each do |x|
            new_coord = {x: x + cell_coord[:x], y: y + cell_coord[:y]}
            next if new_coord[:x] >= @width || new_coord[:y] >= @height || new_coord[:x] < 0 || new_coord[:y] < 0
            cell = @cells[new_coord[:y]][new_coord[:x]]
            next if cell.to_i == 0 || cell.filled
            cell.filled = true
            cell_coords << new_coord
            neighbors_filled += 1
          end
        end
      end
    end
  end

  def find_center_cell_coord(radius)
    radius = 5
    center_x = @width / 2
    center_y = @height / 2
    xs = (center_x - radius..center_x + radius).to_a
    ys = (center_y - radius..center_y + radius).to_a
    until cell_is_live ||= false
      x = xs.sample
      y = ys.sample
      cell_coord = {x: x, y: y}
      cell_is_live = @cells[cell_coord[:y]][cell_coord[:x]].to_i == 1
    end
    cell_coord
  end

  def cell_ratio
    cells = 0
    live = 0
    filled = 0
    @cells.each { |row| row.each { |cell| live += cell.to_i; cells += 1; filled += 1 if cell.filled } }
    ((filled.to_f / cells.to_f) * 100).round
  end

  def to_roguelike_dungeon
    array = @cells.map { |row| row.map { |cell| cell.filled ? @empty_space : @wall } }
    array.each { |row| array.delete(row) if row.uniq.size == 1 }
    array.replace(array.reverse.transpose)
    array.each { |row| array.delete(row) if row.uniq.size == 1 }
    array << Array.new(array.first.length) {@solid_wall}
    array.reverse! << Array.new(array.first.length) {@solid_wall}
    array.replace(array.reverse.transpose)
    array << Array.new(array.first.length) {@solid_wall}
    array.reverse! << Array.new(array.first.length) {@solid_wall}
    @dungeon = array
  end

end

while true
  cave = AutomataCave.new(70, 70, 53).generate!
  system 'clear'
  cave.each { |row| puts row.join('') }
  gets.chomp.downcase
end
