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
          @board[ypos + @radius][xpos + @radius] = "#"
        else
          @board[ypos + @radius][xpos + @radius] = board[@coords[:y] - ypos][@coords[:x] - xpos]
          @board[ypos + @radius][xpos + @radius] ||= "#"
        end
      end
      @board[ypos + @radius].reverse!
    end
    @board.reverse!
  end

  def find_visible
    @board.each_with_index do |x, xpos|
      x.each_with_index do |y, ypos|
        # Carve the square into a circle, check all the points
        # This does the radii points first, to get the longest possble...
        if distance_from_center(xpos, ypos).round == @radius
          @visible += in_linear_view(xpos, ypos)
        elsif distance_from_center(xpos, ypos).round <= @radius
          # Then it fills in the blanks
          unless @visible.include?({x: xpos, y: ypos})
            @visible += in_linear_view(xpos, ypos)
          end
        end
        # "(#{xpos}, #{ypos}) - #{@board[ypos][xpos]}"
      end
    end
    @board.each_with_index do |x, xpos|
      x.each_with_index do |y, ypos|
        if distance_from_center(xpos, ypos).round <= @radius
          unless @visible.include?({x: xpos, y: ypos})
            @visible += in_linear_view(xpos, ypos)
          end
        end
      end
    end
    @visible.uniq!
  end

  def in_linear_view(x, y) #0..@radius*2
    line_coords = get_line(@radius, @radius, x, y).sort_by do |coord|
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
      {x: (@coords[:x] + see[:x] - @radius), y: (@coords[:y] + see[:y] - @radius)}
    end
  end

  def get_line(x0,y0,x1,y1)
    points = []
    steep = ((y1-y0).abs) > ((x1-x0).abs)

    if steep
      x0,y0 = y0,x0
      x1,y1 = y1,x1
    end

    if x0 > x1
      x0,x1 = x1,x0
      y0,y1 = y1,y0
    end

    deltax = x1-x0
    deltay = (y1-y0).abs
    error = (deltax / 2).to_i
    y = y0
    ystep = nil

    if y0 < y1
      ystep = 1
    else
      ystep = -1
    end

    for x in x0..x1
      if steep
        points << {:x => y, :y => x}
      else
        points << {:x => x, :y => y}
      end
      error -= deltay
      if error < 0
        y += ystep
        error += deltax
      end
    end

    return points
  end

  def distance_from_center(x, y)
    return Math.sqrt((x - @radius)**2 + (y - @radius)**2)
  end

end
