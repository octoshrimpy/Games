class Visible

  def initialize(board, coords, radius)
    @block = "\e[31mx\e[0m"
    @visible = []

    @radius = radius.to_i
    @coords = coords
    @old_board = board
    @board = []
    # Cut out a square from the board that we are given with @coords as the center
    (-@radius..@radius).each do |ypos|
      @board[ypos + @radius] ||= []
      (-@radius..@radius).each do |xpos|
        if board[@coords[:y] - ypos].nil? || (@coords[:y] - ypos) < 0
          @board[ypos + @radius][xpos + @radius] = "# "
        else
          @board[ypos + @radius][xpos + @radius] = board[@coords[:y] - ypos][@coords[:x] - xpos]
          @board[ypos + @radius][xpos + @radius] ||= "# "
        end
      end
      @board[ypos + @radius].reverse!
    end
    @board.reverse!
  end

  def self.in_range(range, coords_from, coords_to)
    if Math.distance_between(coords_from, coords_to) <= range
      line_coords = Math.get_line(coords_from[:x], coords_from[:y], coords_to[:x], coords_to[:y])
      line = line_coords.map {|coords| Dungeon.current[coords[:y]][coords[:x]]}
      blocks_in_line = line.map {|e| e.is_solid? ? true : nil}
      blocks_in_line.compact.count == 0
      $visible_calculations += 1
    else
      false
    end
  end

  def find_visible
    # Carve the square into a circle, check all the points
    # This does the radii points first, to get the longest possible-
    # This means drawing a line to every furthest point,
    # which also includes all the points up until that line.
    @board.each_with_index do |x, xpos|
      x.each_with_index do |y, ypos|
        if distance_from_center(xpos, ypos).round == @radius
          @visible += in_linear_view(@radius, @radius, xpos, ypos)
        end
      end
    end
    # Then it fills in the blanks
    @board.each_with_index do |x, xpos|
      x.each_with_index do |y, ypos|
        if distance_from_center(xpos, ypos).round <= @radius
          unless @visible.include?({x: xpos, y: ypos})
            @visible += in_linear_view(@radius, @radius, xpos, ypos)
          end
        end
      end
    end
    # "(#{xpos}, #{ypos}) - #{@board[ypos][xpos]}"
    @visible.uniq!
  end

  def in_linear_view(x0,y0,x1,y1) #0..@radius*2
    # TODO Check Quadrant, do not sort unless necessary.
    $visible_calculations += 1
    line_coords = Math.get_line(x0, y0, x1, y1).sort_by do |coord|
      distance_from_center(coord[:x], coord[:y])
    end
    line = line_coords.map {|coords| @board[coords[:y]][coords[:x]]}

    blocks_in_line = line.map {|e| e.is_solid? ? true : nil}
    if blocks_in_line.compact.count > 0
      visible = line_coords[0..blocks_in_line.index(true)]
    else
      visible = line_coords
    end
    visible.uniq.map do |see|
      {x: (@coords[:x] + see[:x] - x0), y: (@coords[:y] + see[:y] - y0)}
    end
  end

  def distance_from_center(x, y)
    return Math.sqrt((x - @radius)**2 + (y - @radius)**2)
  end

end
