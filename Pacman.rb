require 'io/console'
require 'io/wait'
class Pacman
  def initialize
    @error = ""
    @hold = []
    @targeting = []
    @defaults = {
      wall: "[]",
      blinky: [14, 14, "left", @space],
      blinky_stats: ["∆ ", "idle", 9],
      pinky: [17, 14, "left", @space],
      pinky_stats: ["© ", "idle", 9],
      inky: [17, 13, "left", @space],
      inky_stats: ["® ", "idle", 9],
      clyde: [17, 15, "left", @space],
      clyde_stats: ["Ω ", "idle", 9],
      pellet: ". ",
      space: "  ",
      energy: "ø ",
      energy_swollen: "Ø ",
      pacman_still: "o ",
      pacman_left_open: "> ",
      pacman_left_closed: "- ",
      pacman_right_open: " <",
      pacman_right_closed: " -",
      pacman_vert_closed: "| ",
      pacman_up_open: "v ",
      pacman_down_open: "^ ",
      scared: "† ",
      ghost_dead: "ªª",
      door: "__",
      x: 14,
      y: 26,
      speed: 11,
      width: 28,
      height: 36
    }

    @boardy = @defaults[:height]
    @boardx = @defaults[:width]
    @running = true
    @wall = @defaults[:wall]
    @pellet = @defaults[:pellet]
    @door = @defaults[:door]
    @space = @defaults[:space]
    @energy = []
    [6, 26].each do |blocks|
      [1, 26].each do |block|
        @energy << [blocks, block]
      end
    end
    @energy_face = @defaults[:energy]
    @pacman = @defaults[:pacman_still]
    @scared = @defaults[:scared]
    @lives = 2
    @score = 0
    @stop = 0
    @timer = 0
    @offset = 0
    @next_dir = 0
    @board = Array.new(37) {Array.new(28) {@pellet}}
    @even = true
    @energized = 0
    @dir = 0
    @x = @defaults[:x]
    @y = @defaults[:y]
    @speed = @defaults[:speed]

    @dead_ghost = @defaults[:ghost_dead]

    @blinky = @defaults[:blinky]
    @inky = @defaults[:inky]
    @pinky = @defaults[:pinky]
    @clyde = @defaults[:clyde]

    #face, status, speed-- status(idle, scatter, chase, frightened, dead)
    @blinky_stats = @defaults[:blinky_stats]
    @inky_stats = @defaults[:inky_stats]
    @pinky_stats = @defaults[:pinky_stats]
    @clyde_stats = @defaults[:clyde_stats]
    @ghosts = [@blinky_stats[0], @inky_stats[0], @pinky_stats[0], @clyde_stats[0]]

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
            @board[blocks][block] = @door
          end
        end
        [13, 14, 15, 19, 20, 21].each do |blocks|
          [0, 27].each do |block|
            @board[blocks][block] = @space
          end
        end
        (12..22).each do |blocks|
          @board[blocks].each_with_index do |x, block|
            @board[blocks][block] = @space if @board[blocks][block] == @pellet && !([6, 21].include?(block))
          end
        end
        @board[y][x] = @wall if y == 33
        @board[y][x] = @space if y > 33
        if !([@space, @wall, @pellet, @energy_face].include?(@board[y][x])) && y != 2
          @board[y][x] = @space
        end
      end
    end
    draw
  end

  def tick
    if @running == true
      seconds = @timer - @offset
      control(@blinky, seconds) if @timer % ((20 - @blinky_stats[2]).to_f/50) <= 0.02
      control(@pinky, seconds) if @timer % ((20 - @pinky_stats[2]).to_f/50) <= 0.02
      control(@inky, seconds) if @timer % ((20 - @inky_stats[2]).to_f/50) <= 0.02
      control(@clyde, seconds) if @timer % ((20 - @clyde_stats[2]).to_f/50) <= 0.02
      movePacman if @timer % ((20 - @speed).to_f/50) <= 0.02
      sleep(0.01)
      @timer += 0.02
      draw
    else
      died
    end
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
    location = @board[@y][@x]
    ghost_locations = [[@blinky[0], @blinky[1]], [@pinky[0], @pinky[1]], [@clyde[0], @clyde[1]], [@inky[0], @inky[1]]]
    if location == @pellet
      @score += 1
    elsif @energy_face.include?(location)
      @stop += 1
      @score += 5
      @energized += 60
      [@blinky, @inky, @pinky, @clyde].each { |ghost| reverse(ghost) }
      [@blinky_stats, @pinky_stats, @inky_stats, @clyde_stats].each { |status| status[1] = "frightened" }
      @energy -= [[@y, @x]]
    elsif ghost_locations.include?([@y, @x]) && location != @scared
      @running = false
      died
    end
    if @even == true
      @even = false
      @pacman = case @dir
      when 0
        @defaults[:pacman_still]
      when 1
        @defaults[:pacman_left_closed]
      when 3
        @defaults[:pacman_right_closed]
      when 2, 4
        @defaults[:pacman_vert_closed]
      end
      @energy_face = @defaults[:energy_swollen]
    else
      @even = true
      @energy_face = @defaults[:energy]
      @pacman = case @dir
      when 0
        @defaults[:pacman_still]
      when 1
        @defaults[:pacman_right_open]
      when 2
        @defaults[:pacman_down_open]
      when 3
        @defaults[:pacman_left_open]
      when 4
        @defaults[:pacman_up_open]
      end
    end
  end

  def control(me, seconds)
    case me
    when @blinky
      stats = @blinky_stats
      defaults = @defaults[:blinky_stats]
    when @pinky
      stats = @pinky_stats
      defaults = @defaults[:pinky_stats]
    when @inky
      stats = @inky_stats
      defaults = @defaults[:inky_stats]
    when @clyde
      stats = @clyde_stats
      defaults = @defaults[:clyde_stats]
    end
    myY = me[0]
    myX = me[1]
    dir = me[2]
    below = me[3]
    face = stats[0]
    mode = stats[1]
    speed = stats[2]

    if mode == "frightened"
      if @energized == 0
        mode = "idle"
        face = defaults[0]
      else
        face = @defaults[:scared]
      end
    else
      if seconds < 7 || (seconds > 21 && seconds < 28) || (seconds > 48 && seconds < 55)
        reverse(me) if mode == "chase"
        mode = "scatter"
      else
        reverse(me) if mode == "scatter"
        mode = "chase"
      end
    end
    if me == @pinky
      if seconds <= 2
        mode = "idle"
      end
      if seconds >= 1 && seconds <= 2
        @board[@pinky[0]][@pinky[1]] = @space
        @pinky = [14, 14, "left", @space]
      end
    end
    if me == @inky
      if seconds <= 8
        mode = "idle"
      end
      if seconds >= 7 && seconds <= 8
        @board[@inky[0]][@inky[1]] = @space
        @inky = [14, 14, "left", @space]
      end
    end
    if me == @clyde
      if seconds <= 21
        mode = "idle"
      end
      if seconds >= 20 && seconds <= 21
        @board[@clyde[0]][@clyde[1]] = @space
        @clyde = [14, 14, "left", @space]
      end
    end

    case mode
    when "scatter"
      pathFind(@blinky, @blinky_default_target) if me == @blinky
      pathFind(@pinky, @pinky_default_target) if me == @pinky
      pathFind(@inky, @inky_default_target) if me == @inky
      pathFind(@clyde, @clyde_default_target) if me == @clyde
      @error = "scatter"
    when "chase"
      @error = "chase"
      pathFind(@blinky, [@y, @x]) if me == @blinky
      if me == @pinky
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
      end
      if me == @inky
        vector = distanceTo([@blinky[0], @blinky[1]], [@y, @x], 2)
        pathFind(@inky, [@blinky[0]+vector[0], @blinky[1]+vector[1]])
      end
      if me == @clyde
        dist = distanceTo([@clyde[0], @clyde[1]], [@y, @x])
        if (dist[0].abs + dist[1].abs) >= 8
          pathFind(@clyde, [@y, @x])
        else
          pathFind(@clyde, @clyde_default_target)
        end
      end
    when "frightened"
      @error = "frightened"
      pathFind(me, [rand(@boardy), rand(@boardx)])
      face = @scared
    when "dead"
      face = @dead_ghost
    end

    case me
    when @blinky
      @blinky_stats[0] = face
      @blinky_stats[1] = mode
    when @pinky
      @pinky_stats[0] = face
      @pinky_stats[1] = mode
    when @inky
      @inky_stats[0] = face
      @inky_stats[1] = mode
    when @clyde
      @clyde_stats[0] = face
      @clyde_stats[1] = mode
    end
  end

  def reverse(char)
    char[2] = case char[2]
    when "left"
      "right" if @board[char[0]][(char[1] + 1) % @boardx] != @wall
    when "right"
      "left" if @board[char[0]][(char[1] - 1) % @boardx] != @wall
    when "up"
      "down" if @board[(char[0] + 1) % @boardy][char[1]] != @wall
    when "down"
      "up" if @board[(char[0] - 1) % @boardy][char[1]] != @wall
    else
      char[2]
    end
  end

  def pathFind(char, loc) # Array of target location
    if @running == true
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
      else
        new_x = old_x
        new_y = old_y
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
        if taken != @wall && taken != @door && valid
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

      # if mode == "frightened"
      #   mode = "dead" if @board[new_y][new_x] == @pacman
      # else
        @running = false if @board[new_y][new_x] == @pacman
      # end

      if @ghosts.include?(@board[new_y][new_x])
        tile = @ghosts[@ghosts.index(@board[new_y][new_x])]
      else
        tile = @board[new_y][new_x]
      end
      new_loc = [new_y, new_x, new_dir, tile, char[4]]
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
      @stop = 0
      @offset = @timer
      @next_dir = 0
      @dir = 0
      @x = @defaults[:x]
      @y = @defaults[:y]
      @blinky = @defaults[:blinky]
      @blinky_stats = @defaults[:blinky_stats]
      @pinky = @defaults[:pinky]
      @pinky_stats = @defaults[:pinky_stats]
      @inky = @defaults[:inky]
      @inky_stats = @defaults[:inky_stats]
      @clyde = @defaults[:clyde]
      @clyde_stats = @defaults[:clyde_stats]
      build
      draw
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
    @next_dir = 1 if m == "d"
    @next_dir = 2 if m == "s"
    @next_dir = 3 if m == "a"
    @next_dir = 4 if m == "w"
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
    @board[@blinky[0]][@blinky[1]] = @blinky_stats[0]
    @board[@pinky[0]][@pinky[1]] = @pinky_stats[0]
    @board[@inky[0]][@inky[1]] = @inky_stats[0]
    @board[@clyde[0]][@clyde[1]] = @clyde_stats[0]
    @energy.each { |draw| @board[draw[0]][draw[1]] = @energy_face }
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
