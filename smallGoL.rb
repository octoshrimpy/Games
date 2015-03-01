class GameOfLife
  def initialize
    @board_width = 50
    @board_height = 50
    @live = "0"
    @dead = "."
    @board = Array.new(@board_height) { Array.new(@board_width) {rand(2) == 1 ? @live : @dead} }
  end

  def tick
    new_board = Array.new(@board_height) { Array.new(@board_width) {'x'}}
    @board.each_with_index do |coord, y|
      coord.each_with_index do |pos, x|
        count = count_neighbors(y, x)
        piece = @board[y][x] == @live ? (count == 2 || count == 3 ? @live : @dead) : (count == 3 ? @live : @dead)
        new_board[y][x] = piece
      end
    end
    @board = new_board.clone
  end

  def count_neighbors(y, x)
    count = 0
    (-1..1).each do |vert|
      (-1..1).each do |horz|
        if [horz, vert] != [0, 0]
          count += 1 if @board[(vert + y) % @board_height][(horz + x) % @board_width] == @live
        end
      end
    end
    count
  end

  def draw
    system 'clear' or system 'cls'
    @board.each_with_index do |coord, y|
      coord.each_with_index do |pos, x|
        print "#{@board[y][x]} "
      end
      puts ""
    end
  end
end

game = GameOfLife.new
while true
  game.draw
  game.tick
  sleep 0.3
end
