vert = 9
@board = Array.new(vert*4) {Array.new(vert) {" "}}
@line = "."
def wiperCoords(height, multiplier)
  coords = []
  height.times do |y|
    coords[y] = y <= height / 2 ?
      y + 1 :
      (height*2 - y*2)/2
  end
  wiper = []
  coords.each_with_index do |length, y|
    length.times do |x|
      multiplier.times do |m|
        wiper << [y+(height*m), x]
      end
    end
  end
  wiper.each { |wipe| @board[wipe[0]][wipe[1]] = @line }
  return wiper
end

wiperCoords(vert, 4)

@board.each do |y|
  y.each do |x|
    print x
  end
  puts
end
