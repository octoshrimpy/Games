def clearBoard
  @board = Array.new(20) {Array.new(20) {"."} }
end

def draw
  system 'clear' or system 'cls'
  @board.each {|col| puts col.map {|cell| cell}.join("  ")}
end

def degrees(rad)
  rad * Math::PI / 180
end

def createCoords
  coords = []
  x = @input[0].to_i - 1
  y = @input[1].to_i
  len = @input[2].to_i
  ang = Math::tan(degrees(@input[3].to_i))
  current_x = x
  current_y = y

  i = 0
  while coords.length < len do
    current_x += 1
    current_y = y + (ang * i).round
    puts current_y
    coords << [current_y, current_x]
    i += 1
  end
  coords.each do |coord|
    @board[coord[0]][coord[1]] = "X"
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

  ystep = y0 < y1 ? 1 : -1

  for x in x0..x1
    points << (steep ? {:x => y, :y => x} : {:x => x, :y => y})
    error -= deltay
    if error < 0
      y += ystep
      error += deltax
    end
  end

  return points
end



# system 'clear' or system 'cls'
# puts "X, Y, Length, Angle"
# while true
#   input = gets.chomp
#   system 'clear' or system 'cls'
#   puts "X, Y, Length, Angle"
#   @input = input.split(' ') unless input.nil?
#   @input ||= "0"
#   clearBoard
#   createCoords
#   draw
# end

@board = Array.new(20) {Array.new(20) {'.'} }
while true
  draw

  puts "Enter X Y of first point"
  first_point_x, first_point_y = gets.chomp.split(' ')
  next unless first_point_x && first_point_y
  first_point_x, first_point_y = first_point_x.to_i, first_point_y.to_i

  @board[first_point_y][first_point_x] = 'X'
  draw

  puts "Enter X Y of second point"
  second_point_x, second_point_y = gets.chomp.split(' ')
  next unless second_point_x && second_point_y
  second_point_x, second_point_y = second_point_x.to_i, second_point_y.to_i

  line_points = get_line( first_point_x, first_point_y, second_point_x, second_point_y )
  # puts line_points
  # gets
  line_points.each do |line_point|
    x, y = line_point[:x], line_point[:y]
    @board[y][x] = '.'
  end

end
# puts "X, Y, Length, Angle"
# while true
#   input = gets.chomp
#   system 'clear' or system 'cls'
#   puts "X, Y, Length, Angle"
#   @input = input.split(' ') unless input.nil?
#   @input ||= "0"
#   clearBoard
#   createCoords
#   draw
# end
