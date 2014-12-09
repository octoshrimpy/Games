  #cd C:\Ruby193\Scripts

# cond ? T : F

require 'io/console'
require 'io/wait'
class Tetris

  def initialize
    @pieces = [
      [[1,1],[0,1],[2,1],[3,1]],
      [[1,1],[1,0],[1,2],[0,2]],
      [[1,1],[2,1],[2,2],[2,3]],
      [[1,1],[1,2],[2,2],[2,1]],
      [[1,1],[0,1],[1,2],[2,2]],
      [[1,1],[0,1],[1,0],[2,0]],
      [[1,1],[0,1],[1,0],[1,2]],
    ]
    #ILJOSZT
    @level = 1
    @live = []
    @live_type = ""
    @fast = false
    @running = true
    @falling = false
    @width = 10
    @height = 23
    @origin = [1, 3]
    @count = 0
    @board = Array.new(@height) {Array.new(@width) {". "}}
    @width.times do |x|
      @board[@height - 1][x] = "x "
    end
    @score = 0
  end

  def makePiece
    if @falling == false
      random_num = rand(7)
      @live_type = case random_num
      when 0
        "I "
      when 1
        "L "
      when 2
        "J "
      when 3
        "O "
      when 4
        "S "
      when 5
        "Z "
      when 6
        "T "
      end
      buildPiece(@pieces[random_num])
      @falling = true
    end
  end

  def buildPiece(piece)
    piece.each do |chunk|
      y = @origin[0] + chunk[0]
      x = @origin[1] + chunk[1]
      @board[y][x] = @live_type
      @live << [y, x]
    end
  end

  def step
    @level = (@score / 50) + 1
    @level = 10 if @level > 10
    bps = (11 - @level) * 2
    bps = 1 if @fast

    if @count >= bps
      move([1,0])
      @count = 0
    end
    @count += 1
    draw
  end

  def move(move_to)
    can_move = true
    @live.each do |piece|
      can_move = false if checkCollisions(piece, move_to)
    end
    if can_move == true
      @live.each do |old_pos|
        @board[old_pos[0]][old_pos[1]] = ". "
      end
      new_pos = []
      @live.each do |old_pos|
        new_y = old_pos[0] + move_to[0]
        new_x = old_pos[1] + move_to[1]
        @board[new_y][new_x] = @live_type
        new_pos << [new_y, new_x]
      end
      @live = new_pos
    elsif move_to == [1,0]
      stopped
    end
  end

  def stopped
    @live = []
    @fast = false
    @falling = false
    @score += 4
    checkLines
  end

  def checkLines
    completed = []
    @height.times do |row|
      if !(@board[row].join.include?(". ") || @board[row].join.include?("x "))
        completed << row
      end
    end
    @score += @level * (completed.length * 20)
    removeRow(completed)
    checkCeiling
  end

  def removeRow(y)
    y.each do |pos|
      @width.times do |kill|
        @board[pos][kill] = ". "
      end
      pos.times do |drop|
        @width.times do |x|
          new_cell = @board[(pos - 1) - drop][x]
          @board[(pos - 1) - drop][x] = ". "
          @board[(pos - 1) - drop + 1][x] = new_cell
        end
      end
    end
  end

  def checkCeiling
    if @board[@origin[0] + 1][@origin[1] + 1] == ". "
      makePiece
    else
      died
    end
  end

  def checkCollisions(piece, coord)
    checkOpen([piece[0] + coord[0],piece[1] + coord[1]])
  end

  def checkOpen(new_coord)
    left = new_coord[1] >= 0
    right = new_coord[1] < @width
    low = new_coord[0] < @height
    blank = @board[ new_coord[0] ][ new_coord[1] ] == ". "
    not_self = @live.include?([new_coord[0],new_coord[1]])
    if left && right && low && (blank || not_self)
      return false
    else
      return true
    end
  end

  def rotate
    matrix = []
    new_matrix = []
    offset_y = @live.sort_by(&:first)[0][0]
    offset_x = @live.sort_by(&:last)[0][1]
    @live.sort_by(&:first).each do |stabilize|
      new_matrix << [stabilize[0] - offset_y , stabilize[1] - offset_x]
    end
    new_matrix = case @live_type
    when "I "
      if new_matrix[1] == [1,0]
        [[1,-1],[1,0],[1,1],[1,2]]
      else
        [[1,1],[0,1],[2,1],[3,1]]
      end
    when "L "
      if new_matrix[0] == [0, 2] #[[0, 2], [1, 2], [1, 0], [1, 1]] Left
        [[0,1],[1,1],[2,1],[2,2]]
      elsif new_matrix[2] == [2, 0] #[[0, 0], [1, 0], [2, 0], [2, 1]] Up
        [[1,0],[1,-1],[1,1],[2,-1]]
      elsif new_matrix[0] == [0,1] #[[0, 1], [0, 0], [0, 2], [1, 0]] Right
        [[-1,0],[-1,1],[0,1],[1,1]]
      else #[[0, 0], [0, 1], [1, 1], [2, 1]]
        [[1,1],[1,0],[1,2],[0,2]]
      end
    when "J "
      if new_matrix[1] == [0, 1] #[[0, 0], [0, 1], [1, 0], [2, 0]]
        [[2,1],[1,-1],[1,0],[1,1]] #Left
      elsif new_matrix[0] == [0, 2] #[[0, 2], [0, 0], [0, 1], [1, 2]]
        [[-1,1],[0,1],[1,1],[1,0]] #UP
      elsif new_matrix[0] == [0, 1] #[[0, 1], [1, 1], [2, 1], [2, 0]]
        [[0,0],[1,0],[1,1],[1,2]] #Right - default
      else
        [[0,1],[1,1],[2,1],[0,2]] #Down
      end
    when "S "
      if new_matrix[0] == [0, 0] #[[0, 0], [1, 0], [1, 1], [2, 1]]
        [[1,0],[1,1],[2,0],[2,-1]]
      else #[[0, 1], [0, 2], [1, 1], [1, 0]]
        [[-1, 1], [0, 1], [0, 2], [1, 2]]
      end
    when "Z "
      if new_matrix[0] == [0, 1] #[[0, 1], [1, 1], [1, 0], [2, 0]]
        [[1,0], [1,1], [2,1], [2,2]]
      else
        [[0,1],[-1,1],[0,0],[1,0]]
      end
    when "T "
      if new_matrix.last == [1, 2] #[[0, 1], [1, 0], [1, 1], [1, 2]]
        [[1,1],[0,1],[1,2],[2,1]]
      elsif new_matrix[1] == [1,0] #[[0, 0], [1, 0], [1, 1], [2, 0]]
        [[1,0],[1,-1],[1,1],[2,0]]
      elsif new_matrix.last == [1, 1] #[[0, 0], [0, 1], [0, 2], [1, 1]]
        [[1,1],[1,0],[0,1],[2,1]]
      elsif new_matrix[0] == [0, 1] #
        [[1,1],[1,0],[0,1],[1,2]]
      else
      [[1,1],[1,3],[3,3],[3,1]]
      end
    else
      [[1,1],[1,3],[3,3],[3,1]]
    end
    new_matrix.each do |bounceback|
      matrix << [bounceback[0] + offset_y, bounceback[1] + offset_x]
    end
    redraw(matrix)
  end

  def redraw(new_matrix)
    @live.each do |delete|
      @board[delete[0]][delete[1]] = ". "
    end

    can_move = true
    new_matrix.each do |check|
      can_move = false if checkOpen(check)
    end
    @live = new_matrix if can_move == true

    @live.each do |draw|
      @board[draw[0]][draw[1]] = @live_type
    end
  end

  def died
    system "stty -raw echo"
    @running = false
  end

  def keysInput(m)
    rotate if m == "w" #Move up
    move([0,-1]) if m == "a" #Move left
    move([0,1]) if m == "d" #Move right
    @fast = true if m == "s" #Move down
    died if m == "x"
  end

  def draw
    system "stty -raw echo"
    system "clear" or system "cls"
    print "  "
    21.times do print "-" end
    puts ""
    i = 2
    while i < @board.length - 1
      print " | "
      print @board[i].join
      puts "|"
      i += 1
    end
    print "  "
    21.times do print "-" end
    puts ""
    p @score
    system "stty raw -echo"
  end
end

game = Tetris.new
game.makePiece

prompt = Thread.new do
  loop do
    game.keysInput(s = STDIN.getch)
  end
end

loop do
  if game.instance_variable_get(:@running) == true
    game.step
    sleep 0.05
  else
    prompt = 0
    break
  end
end
