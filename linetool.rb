def clearBoard
  @board = Array.new(20) {Array.new(20) {"."} }
end

def draw
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



while true
  input = gets.chomp
  @input = input.split(' ') unless input.nil?
  @input ||= "0"
  clearBoard
  createCoords
  draw
end
