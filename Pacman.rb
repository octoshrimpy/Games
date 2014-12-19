require 'io/console'
require 'io/wait'
class Pacman
  def initialize
    @boardy = 36
    @boardx = 28
    @running = true
    @wall = "[]"
    @pellet = ". "
    @space = "  "
    @energy = "ø "
    @pacman = "o "
    @candy = "å "
    @lives = 3
    @score = 0
    @stop = 5
    @timer = 0
    @offset = 0
    @board = Array.new(35) {Array.new(28) {@pellet}}
    @even = true
    @energized = false
    @dir = 0
    @x = 14
    @y = 26

    @blinky_face = "∆ " #J
    @inky_face = "® " #R
    @pinky_face = "© " #G
    @clyde_face = "Ω " #Z
    @ghosts = ["Ω ", "© ", "® ", "∆ "]
    @dead_ghost = "ªª"

    @blinky = [14, 14, "left"]
    @inky = [17, 13, "left"]
    @pinky = [17, 14, "left"]
    @clyde = [17, 15, "left"]

    @blinky_default_target = [0, @boardx - 1]
    @inky_default_target =  [@boardy - 1, @boardx - 1]
    @pinky_default_target = [0, 0]
    @clyde_default_target = [@boardy - 1, 0]
  end

  def createBoard
    @board.each_with_index do |col, y|
      col.each_with_index do |row, x|
        @board[y][x] = @space if y < 3
        @board[y][x] = @wall if y == 3
        # Central Column
        ((4..31).to_a - [8, 14, 16, 17, 18, 20, 26]).each do |blocks|
          [0, 13, 14, 27].each do |block|
            @board[blocks][block] = @wall
          end
        end
        # Top sections, first bottom section
        [5, 6, 7, 24, 25].each do |blocks|
          ((2..25).to_a - [6, 12, 13, 14, 15, 21]).each do |block|
            @board[blocks][block] = @wall
          end
        end
        # Top second sections
        [9, 10].each do |blocks|
          ((2..25).to_a - [1, 6, 9, 18, 21]).each do |block|
            @board[blocks][block] = @wall
          end
        end
        ((11..22).to_a - [17]).each do |blocks|
          [7, 8, 19, 20].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [12, 13].each do |blocks|
          ((7..20).to_a - [12, 15]).each do |block|
            @board[blocks][block] = @wall
          end
        end
        [12, 16, 18, 22].each do |blocks|
          ((1..5).to_a + (22..26).to_a).each do |block|
            @board[blocks][block] = @wall
          end
        end
        [13, 14, 15, 19, 20, 21].each do |blocks|
          [5, 22].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [8, 16, 18, 26, 32].each do |blocks|
          [0, 27].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [15, 19, 21, 22, 27, 28].each do |blocks|
          (10..17).each do |block|
            @board[blocks][block] = @wall
          end
        end
        [16, 17, 18].each do |blocks|
          [10, 17].each do |block|
            @board[blocks][block] = @wall
          end
        end
        (26..28).each do |blocks|
          [4, 5, 23, 22].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [27, 28].each do |blocks|
          [1, 2, 25, 26].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [30, 31].each do |blocks|
          ((2..25).to_a - [12, 15]).each do |block|
            @board[blocks][block] = @wall
          end
        end
        (27..29).each do |blocks|
          [7, 8, 19, 20].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [15].each do |blocks|
          [13, 14].each do |block|
            @board[blocks][block] = "__"
          end
        end
        [13, 14, 15, 19, 20, 21].each do |blocks|
          [0, 27].each do |block|
            @board[blocks][block] = @space
          end
        end
        [6, 26].each do |blocks|
          [1, 26].each do |block|
            @board[blocks][block] = @energy
          end
        end
        (12..22).each do |blocks|
          @board[blocks].each_with_index do |x, block|
            @board[blocks][block] = @space if @board[blocks][block] == @pellet && !([6, 21].include?(block))
          end
        end
        @board[y][x] = @wall if y == 33
        @board[y][x] = @space if y > 33
      end
    end
    @board[@y][@x] = @pacman
    @board[@blinky[0]][@blinky[1]] = @blinky_face
    @board[@pinky[0]][@pinky[1]] = @pinky_face
    @board[@inky[0]][@inky[1]] = @inky_face
    @board[@clyde[0]][@clyde[1]] = @clyde_face
    draw
  end

  def tick
    moveGhosts
    if @even == true
      @even = false
      @pacman = case @dir
      when 0
        "o "
      when 1, 3
        "- "
      when 2, 4
        "| "
      end
      @energy = "  "
    else
      @even = true
      @energy = "ø "
      @pacman = case @dir
      when 0
        "o "
      when 1
        "< "
      when 2
        "^ "
      when 3
        "> "
      when 4
        "v "
      end
    end
    @board[@y][@x] = @space
    if @stop == 0
      case @dir
      when 1
        @board[@y][((@x + 1) % @boardx)] != @wall ? @x = (@x + 1) % @boardx : @dir = 0
      when 2
        @board[((@y + 1) % @boardy)][@x] != @wall ? @y = (@y + 1) % @boardy : @dir = 0
      when 3
        @board[@y][((@x - 1) % @boardx)] != @wall ? @x = (@x - 1) % @boardx : @dir = 0
      when 4
        @board[((@y - 1) % @boardy)][@x] != @wall ? @y = (@y - 1) % @boardy : @dir = 0
      when 0
        @dir = 0
      end
    else
      @stop -= 1
    end
    case @board[@y][@x]
    when @pellet
      @score += 1
    when @blinky_face, @pinky_face, @inky_face, @clyde_face
      died
    end
    @timer += 0.5
    sleep(0.3)
    createBoard
  end

  def moveGhosts #@mode: Scatter, Chase, Frightened
    seconds = @timer - @offset
    # if seconds < 7 || (seconds > 20 && seconds < 27) || (seconds > 47 && seconds < 54)
     mode = "scatter"
    # else
    #  mode = "chase"
    # end
    mode = "energized" if @energized
    if mode == "scatter"
      pathFind(@blinky, @blinky_default_target)
      pathFind(@inky, @inky_default_target)
      pathFind(@pinky, @pinky_default_target)
      pathFind(@clyde, @clyde_default_target)
    end
    if mode == "chase"
    end
    if mode == "frightened"
    end
  end

  def pathFind(char, loc) # Array of target location
    old_x = char[0]
    old_y = char[1]
    dir = char[2]
    new_x = loc[0]
    new_y = loc[1]
  end

  def died
    if @lives > 0
      @lives -= 1
      @x = 14
      @y = 26
      @dir = 0
      @stop = 5
      @offset = @timer
      @blinky = [14, 14]
      @inky = [17, 13]
      @pinky = [17, 14]
      @clyde = [17, 15]
    else
      @running = false
      exit
    end
  end

  def movement(m)
    m = m[0]
    #stopped = 0
    # left = 1
    # up = 2
    # right = 3
    # down = 4
    if m == "d" && @board[@y][((@x + 1) % @boardx)] != @wall #Move right
      @dir = 1
    end
    if m == "s" && @board[((@y + 1) % @boardy)][@x] != @wall #Move down
      @dir = 2
    end
    if m == "a" && @board[@y][((@x - 1) % @boardx)] != @wall #Move left
      @dir = 3
    end
    if m == "w" && @board[((@y - 1) % @boardy)][@x] != @wall #Move up
      @dir = 4
    end
    if m == "x"
      @running = false
      exit
    end
  end

  def draw
    system "stty -raw echo"
    system "clear" or system "cls"
    i = 0
    while i < @board.length
      puts @board[i].join(" ")
      i += 1
    end
    count = 0
    @board.each do |y|
      y.each do |x|
        count += 1 if x == ". "
      end
    end
    p @timer.round
    p @score
    system "stty raw -echo"
  end
end

game = Pacman.new
game.createBoard

prompt = Thread.new do
  loop do
    game.movement(s = STDIN.getch.downcase)
  end
end

loop do
  if game.instance_variable_get(:@running) == true
    game.tick
  else
    prompt = 0
    break
  end
end
