require 'io/console'
require 'io/wait'
class Pacman
  def initialize
    @error = ""
    @hold = []
    @targeting = []

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
    @stop = 0
    @timer = 0
    @offset = 0
    @next_dir = 0
    @board = Array.new(37) {Array.new(28) {@pellet}}
    @even = true
    @energized = 0
    @dir = 0
    @x = 14
    @y = 26

    @blinky_face = "∆ " #J
    @inky_face = "® " #R
    @pinky_face = "© " #G
    @clyde_face = "Ω " #Z
    @ghosts = [@blinky_face, @inky_face, @pinky_face, @clyde_face]
    @dead_ghost = "ªª"

    @blinky = [14, 14, "left", @space]
    @inky = [17, 13, "left", @space]
    @pinky = [17, 14, "left", @space]
    @clyde = [17, 15, "left", @space]

    @blinky_default_target = [1, @boardx - 3]
    @inky_default_target =  [@boardy - 1, @boardx - 1]
    @pinky_default_target = [1, 2]
    @clyde_default_target = [@boardy - 1, 0]
  end

  def build
    @board.each_with_index do |col, y|
      col.each_with_index do |row, x|
        @board[y][x] = @space if y < 2
        if y == 2
          num = x.to_s
          if x == 0
            num.reverse!
            num += "   "
            num.reverse!
          end
          num += " " if x < 10
          @board[y][x] = num
        end
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
    draw
  end

  def tick
    if @running == true
      moveGhosts if @timer % 0.3 <= 0.02
      moveDeadGhost
      movePacman if @timer % 0.2 <= 0.02
      displayTargeting
      sleep(0.01)
      @timer += 0.02
      draw
    else
      died
    end
  end

  def displayTargeting
    @hold << [0, 0, @space]
    @hold.each do |pos|
      @board[pos[0]][pos[1]] = pos[2]
    end
    @hold = []
    @targeting.each do |pos|
      if pos[0] == @y && pos[1] == @x
        @hold << [34, 1, @board[34][1]]
        @board[34][1] = "XXX"
      else
        if pos[0] < @boardy && pos[1] < @boardx
          @hold << [pos[0], pos[1], @board[pos[0]][pos[1]]]
          @board[pos[0]][pos[1]] = "XXX"
        end
      end
    end
    @targeting = []
  end

  def moveDeadGhost
  end

  def movePacman
    @board[@y][@x] = @space
    @energized -= 1 if @energized > 0
    if @stop == 0
      case @next_dir
      when 1
        @dir = @next_dir if @board[@y][((@x + 1) % @boardx)] != @wall
      when 2
        @dir = @next_dir if @board[((@y + 1) % @boardy)][@x] != @wall
      when 3
        @dir = @next_dir if @board[@y][((@x - 1) % @boardx)] != @wall
      when 4
        @dir = @next_dir if @board[((@y - 1) % @boardy)][@x] != @wall
      end
      case @dir
      when 1
        @board[@y][((@x + 1) % @boardx)] != @wall ? @x = (@x + 1) % @boardx : @dir = @next_dir
      when 2
        @board[((@y + 1) % @boardy)][@x] != @wall ? @y = (@y + 1) % @boardy : @dir = @next_dir
      when 3
        @board[@y][((@x - 1) % @boardx)] != @wall ? @x = (@x - 1) % @boardx : @dir = @next_dir
      when 4
        @board[((@y - 1) % @boardy)][@x] != @wall ? @y = (@y - 1) % @boardy : @dir = @next_dir
      when 0
        @dir = 0
      end
    else
      @stop -= 1
    end
    case @board[@y][@x]
    when @pellet
      @score += 1
    when @energy
      @stop += 1
      @energized = 60
    when @blinky_face, @pinky_face, @inky_face, @clyde_face
      # @running = false
    end
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
      # @energy = "  "
    else
      @even = true
      # @energy = "ø "
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
  end

  def moveGhosts #@mode: Scatter, Chase, Frightened
    seconds = @timer - @offset
    if seconds < 7 || (seconds > 21 && seconds < 28) || (seconds > 48 && seconds < 55)
     reverse if mode == "chase"
     mode = "scatter"
    else
     reverse if mode == "scatter"
     mode = "chase"
    end
    if seconds >= 2 && seconds <= 3
      @pinky = [14, 14, "left", @space]
      @board[17][14] = @space
    end
    if seconds >= 7 && seconds <= 8
      @inky = [14, 14, "left", @space]
      @board[17][13] = @space
    end
    if seconds >= 20 && seconds <= 21
      @clyde = [14, 14, "left", @space]
      @board[17][15] = @space
    end
    mode = "frightened" if @energized > 0
    if mode == "scatter"
      pathFind(@blinky, @blinky_default_target)
      pathFind(@pinky, @pinky_default_target) if seconds > 3
      pathFind(@inky, @inky_default_target) if seconds > 8
      pathFind(@clyde, @clyde_default_target) if seconds > 21
    end
    if mode == "chase"
      #  Blinky
      pathFind(@blinky, [@y, @x])
      #  Pinky
      case @dir
      when "left"
        pathFind(@pinky, [@y, (@x - 4) % @boardx])
      when "right"
        pathFind(@pinky, [@y, (@x + 4) % @boardx])
      when "up"
        pathFind(@pinky, [(@y - 4) % @boardy, @x])
      when "down"
        pathFind(@pinky, [(@y + 4) % @boardy, @x])
      else
        pathFind(@pinky, [@y, @x])
      end
      #  Inky
      vector = distanceTo([@blinky[0], @blinky[1]], [@y, @x], 2)
      pathFind(@inky, [@blinky[0]+vector[0], @blinky[1]+vector[1]])
      #  Clyde
      dist = distanceTo([@clyde[0], @clyde[1]], [@y, @x])
      if (dist[0].abs + dist[1].abs) >= 8
        pathFind(@clyde, [@y, @x])
      else
        pathFind(@clyde, @clyde_default_target)
      end
    end
    if mode == "frightened"
    end
  end

  def reverse
    @blinky[2] = case @blinky[2]
    when "left"
      "right"
    when "right"
      "left"
    when "up"
      "down"
    when "down"
      "up"
    end
    @clyde[2] = case @clyde[2]
    when "left"
      "right"
    when "right"
      "left"
    when "up"
      "down"
    when "down"
      "up"
    end
    @pinky[2] = case @pinky[2]
    when "left"
      "right"
    when "right"
      "left"
    when "up"
      "down"
    when "down"
      "up"
    end
    @inky[2] = case @inky[2]
    when "left"
      "right"
    when "right"
      "left"
    when "up"
      "down"
    when "down"
      "up"
    end
  end

  def pathFind(char, loc) # Array of target location
    if @running == true
      @targeting << loc if char == @inky
      old_y = char[0]
      old_x = char[1]
      dir = char[2]
      @board[old_y][old_x] = char[3]
      case dir
      when "left"
        new_x = ((old_x - 1) % @boardx)
        new_y = old_y
      when "right"
        new_x = ((old_x + 1) % @boardx)
        new_y = old_y
      when "up"
        new_x = old_x
        new_y = ((old_y - 1) % @boardy)
      when "down"
        new_x = old_x
        new_y = ((old_y + 1) % @boardy)
      end
      up = [((new_y - 1) % @boardy), new_x]
      left = [new_y, ((new_x - 1) % @boardx)]
      down = [((new_y + 1) % @boardy), new_x]
      right = [new_y, ((new_x + 1) % @boardx)]
      distances = []
      [up, left, down, right].each do |pos|
        taken = @board[pos[0]][pos[1]]
        old = [new_y, new_x]
        bad_loc = [[14, 12], [14, 15], [26, 12], [26, 15]]
        valid = true
        if pos == up
          valid = false if dir == "down" || bad_loc.include?(old)
        end
        valid = false if pos == down && dir == "up"
        valid = false if pos == right && dir == "left"
        valid = false if pos == left && dir == "right"
        if taken != @wall && taken != "__" && valid
          dist = distanceTo(pos, loc)
          distances << (dist[0].abs + dist[1].abs)
        else
          distances << 10000
        end
      end
      new_dir = case distances.index(distances.min)
      when 0
        "up"
      when 1
        "left"
      when 2
        "down"
      when 3
        "right"
      end
      @running = false if @board[new_y][new_x] == @pacman
      if @ghosts.include?(@board[new_y][new_x])
        tile = @space
      else
        tile = @board[new_y][new_x]
      end
      new_loc = [new_y, new_x, new_dir, tile]
      case char
      when @blinky
        @blinky = new_loc
      when @inky
        @inky = new_loc
      when @pinky
        @pinky = new_loc
      when @clyde
        @clyde = new_loc
      end
    end
  end

  def distanceTo(from, to, multiplier=1)
    return [((to[0] - from[0])*multiplier), ((to[1] - from[1])*multiplier)]
  end

  def died
    if @lives > 0
      @lives -= 1
      @running = true
      @stop = 5
      @offset = @timer
      @board[@y][@x] = @space
      @dir = 0
      @x = 14
      @y = 26
      @board[@blinky[0]][@blinky[1]] = @blinky[3]
      @blinky = [14, 14, "left", @space]
      @board[@pinky[0]][@pinky[1]] = @pinky[3]
      @pinky = [17, 14, "left", @space]
      @board[@inky[0]][@inky[1]] = @inky[3]
      @inky = [17, 13, "left", @space]
      @board[@clyde[0]][@clyde[1]] = @clyde[3]
      @clyde = [17, 15, "left", @space]
      getReady("Get Ready!")
    else
      exit
    end
  end

  def getReady(msg)
    retrieve = []
    error = msg.to_s.split("")
    start = error.length/2
    error.each_with_index do |letter, pos|
      retrieve << @board[20][(14 - start) + pos]
      @board[20][(14 - start) + pos] = letter + " "
    end
    draw
    sleep(3)
    retrieve.each_with_index do |letter, pos|
      @board[20][(14 - start) + pos] = letter
    end
    draw
  end

  def movement(m)
    m = m[0]
    #stopped = 0
    # left = 1
    # up = 2
    # right = 3
    # down = 4
    if m == "d" #&& @board[@y][((@x + 1) % @boardx)] != @wall #Move right
      @next_dir = 1
    end
    if m == "s" #&& @board[((@y + 1) % @boardy)][@x] != @wall #Move down
      @next_dir = 2
    end
    if m == "a" #&& @board[@y][((@x - 1) % @boardx)] != @wall #Move left
      @next_dir = 3
    end
    if m == "w" #&& @board[((@y - 1) % @boardy)][@x] != @wall #Move up
      @next_dir = 4
    end
    if m == "x"
      @running = false
      exit
    end
  end

  def makeMark(loc)
    @board[loc[0]][loc[1]] = "XX"
  end

  def draw
    @board[@y][@x] = @pacman
    @board[@blinky[0]][@blinky[1]] = @blinky_face
    @board[@pinky[0]][@pinky[1]] = @pinky_face
    @board[@inky[0]][@inky[1]] = @inky_face
    @board[@clyde[0]][@clyde[1]] = @clyde_face
    system "stty -raw echo"
    system "clear" or system "cls"
    i = 0
    while i < @board.length
      if i > 2 && i < 34
        print i
        print " "
        print " " if i < 10
      end
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
    p @error
    system "stty raw -echo"
  end

end

game = Pacman.new
game.build
game.getReady("Get Ready!")

prompt = Thread.new do
  loop do
    game.movement(s = STDIN.getch.downcase)
  end
end

loop do
  game.tick
end
