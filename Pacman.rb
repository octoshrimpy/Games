require 'io/console'
require 'io/wait'
class Pacman
  def initialize
    @error = ""
    @hold = []
    @targeting = []
    @space = "  "

    @defaults = {
      wall: "[]",
      blinky: {
        y: 14,
        x: 14,
        target: [1, 25],
        direction: "left",
        below: @space,
        face: "Ω ",
        status: "idle",
        speed: 75
      },
      pinky: {
        y: 17,
        x: 14,
        target: [1, 2],
        direction: "left",
        below: @space,
        face: "¥ ",
        status: "idle",
        speed: 75
      },
      inky: {
        y: 17,
        x: 13,
        target: [35, 27],
        direction: "left",
        below: @space,
        face: "∑ ",
        status: "idle",
        speed: 75
      },
      clyde: {
        y: 17,
        x: 15,
        target: [35, 0],
        direction: "left",
        below: @space,
        face: "∆ ",
        status: "idle",
        speed: 75
      },
      pellet: ". ",
      space: @space,
      energy: "ø ",
      energy_swollen: "Ø ",
      candy: "å ",
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
      speed: 80,
      width: 28,
      height: 36
    }

    @boardy = @defaults[:height]
    @boardx = @defaults[:width]
    @wall = @defaults[:wall]
    @pellet = @defaults[:pellet]
    @door = @defaults[:door]
    @board = Array.new(37) {Array.new(28) {@pellet}}
    @energy = []
    [6, 26].each do |blocks|
      [1, 26].each do |block|
        @energy << [blocks, block]
      end
    end
    @energy_face = @defaults[:energy]

    @running = true
    @lives = 2
    @score = 0
    @stop = 0
    @timer = 0
    @offset = 0
    @next_dir = 0
    @even = true
    @energized = 0
    @count = 240
    @fizzle_treat = 0

    @pacman = @defaults[:pacman_still]
    @dir = 0
    @x = @defaults[:x]
    @y = @defaults[:y]
    @treat = 0
    @consecutive = 0
    @capture_all = 0
    @speed = @defaults[:speed]

    @dead_ghost = @defaults[:ghost_dead]
    @scared = @defaults[:scared]
    @blinky = @defaults[:blinky].clone
    @inky = @defaults[:inky].clone
    @pinky = @defaults[:pinky].clone
    @clyde = @defaults[:clyde].clone
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
      movePacman if @timer % ((100 - (@speed + 1)).to_f/100) <= 0.02
      [@blinky, @pinky, @inky, @clyde].each do |ghost|
        equation = 100 - (ghost[:speed] - 1).to_f
        control(ghost, seconds) if @timer % (equation/100) <= 0.02 if equation > 0
      end
      sleep(0.01)
      @timer += 0.02
      draw
    else
      died
    end
  end

  def score(str)
    case str
    when 'pellet'
      @score += 10
    when 'energy'
      @consecutive = 0
      @stop += 1
      @score += 50
      @energized += 60
      [@blinky, @inky, @pinky, @clyde].each do |ghost|
        reverse(ghost)
        ghost[:status] = "frightened" if ghost[:status] != "dead"
      end
      @energy -= [[@y, @x]]
    when 'candy'
      @score += 200
    end

  end

  def movePacman
    @board[@y][@x] = @space
    @energized -= 1 if @energized > 0
    if @stop == 0
      case @next_dir
      when 1
        @dir = @next_dir if @board[@y][((@x + 1) % @boardx)] != @wall && @board[@y][((@x + 1) % @boardx)] != @door
      when 2
        @dir = @next_dir if @board[((@y + 1) % @boardy)][@x] != @wall && @board[((@y + 1) % @boardy)][@x] != @door
      when 3
        @dir = @next_dir if @board[@y][((@x - 1) % @boardx)] != @wall && @board[@y][((@x - 1) % @boardx)] != @door
      when 4
        @dir = @next_dir if @board[((@y - 1) % @boardy)][@x] != @wall && @board[((@y - 1) % @boardy)][@x] != @door
      end
      case @dir
      when 1
        @board[@y][((@x + 1) % @boardx)] != @wall && @board[@y][((@x + 1) % @boardx)] != @door ? @x = (@x + 1) % @boardx : @dir = @next_dir
      when 2
        @board[((@y + 1) % @boardy)][@x] != @wall && @board[((@y + 1) % @boardy)][@x] != @door ? @y = (@y + 1) % @boardy : @dir = @next_dir
      when 3
        @board[@y][((@x - 1) % @boardx)] != @wall && @board[@y][((@x - 1) % @boardx)] != @door ? @x = (@x - 1) % @boardx : @dir = @next_dir
      when 4
        @board[((@y - 1) % @boardy)][@x] != @wall && @board[((@y - 1) % @boardy)][@x] != @door ? @y = (@y - 1) % @boardy : @dir = @next_dir
      when 0
        @dir = 0
      end
    else
      @stop -= 1
    end

    location = @board[@y][@x]
    ghost_locations = [[@blinky[:y], @blinky[:x]], [@pinky[:y], @pinky[:x]], [@clyde[:y], @clyde[:x]], [@inky[:y], @inky[:x]]]
    if location == @pellet
      score('pellet')
    elsif location == @defaults[:candy]
      score('candy')
    elsif @energy_face.include?(location)
      score('energy')
    elsif ghost_locations.include?([@y, @x])
      enemy = case ghost_locations.index([@y, @x])
      when 0
        @blinky
      when 1
        @pinky
      when 2
        @clyde
      when 3
        @inky
      end
      if enemy[:status] == "frightened"
        enemy[:status] = "dead"
        enemy[:face] = @ghost_dead
        if enemy[:below] == @pellet
          enemy[:below] = @space
          score('pellet')
        end
        if enemy[:below] == @defaults[:candy]
          enemy[:below] = @space
          score('candy')
        end
        consec_check
      end
    end

    if @even == true
      @even = false
      @pacman = case @dir
      when 0
        @defaults[:pacman_still]
      when 3
        @defaults[:pacman_left_closed]
      when 1
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
    myY = me[:y]
    myX = me[:x]
    dir = me[:direction]
    below = me[:below]
    face = me[:face]
    mode = me[:status]
    speed = me[:speed]

    defaults = case me
    when @blinky
      @defaults[:blinky]
    when @pinky
      @defaults[:pinky]
    when @inky
      @defaults[:inky]
    when @clyde
      @defaults[:clyde]
    end

    if mode == "frightened"
      if @energized <= 0
        face = defaults[:face]
        me[:status] = mode = "idle"
      else
        face = @scared
      end
    end
    if !(mode == "frightened" || mode == "dead")
      if seconds < 7 || (seconds > 21 && seconds < 28) || (seconds > 48 && seconds < 55)
        reverse(me) if mode == "chase"
        me[:status] = "scatter"
      else
        reverse(me) if mode == "scatter"
        me[:status] = "chase"
      end
    end
    if me == @pinky
      if seconds <= 2
        speed = 0
      end
      if seconds >= 1 && seconds <= 2
        @board[@pinky[:y]][@pinky[:x]] = @space
        @pinky[:y] = 14
        @pinky[:x] = 14
        @pinky[:direction] = "left"
        @pinky[:below] = @space
      end
    end
    if me == @inky
      if seconds <= 8
        speed = 0
      end
      if seconds >= 7 && seconds <= 8
        @board[@inky[:y]][@inky[:x]] = @space
        @inky[:y] = 14
        @inky[:x] = 14
        @inky[:direction] = "left"
        @inky[:below] = @space
      end
    end
    if me == @clyde
      if seconds <= 21
        speed = 0
      end
      if seconds >= 20 && seconds <= 21
        @board[@clyde[:y]][@clyde[:x]] = @space
        @clyde[:y] = 14
        @clyde[:x] = 14
        @clyde[:direction] = "left"
        @clyde[:below] = @space
      end
    end

    case me[:status]
      when "scatter"
        face = defaults[:face]
        speed = defaults[:speed]
        mode = pathFind(@blinky, @blinky[:target]) if me == @blinky
        mode = pathFind(@pinky, @pinky[:target]) if me == @pinky
        mode = pathFind(@inky, @inky[:target]) if me == @inky
        mode = pathFind(@clyde, @clyde[:target]) if me == @clyde
      when "chase"
        speed = defaults[:speed]
        face = defaults[:face]
        if me == @blinky
          mode = pathFind(@blinky, [@y, @x])
          speed = 37
        end
        if me == @pinky
          mode = case @dir
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
          vector = distanceTo([@blinky[:y], @blinky[:x]], [@y, @x], 2)
          mode = pathFind(@inky, [@blinky[:y]+vector[0], @blinky[:x]+vector[1]])
        end
        if me == @clyde
          dist = distanceTo([@clyde[:y], @clyde[:x]], [@y, @x])
          if (dist[0].abs + dist[1].abs) >= 8
            mode = pathFind(@clyde, [@y, @x])
          else
            mode = pathFind(@clyde, @clyde[:target])
          end
        end
      when "frightened"
        mode = pathFind(me, [rand(@boardy), rand(@boardx)])
        face = @scared
        speed = 20
      when "dead"
        face = @dead_ghost
        mode = pathFind(me, [17, 14])
        speed = 45
      when "idle"
        speed = 20
        face = "x "
    end

    speed /= 2 if (myX <= 5 || myX >= 22) && myY == 17

    case me
      when @blinky
        @blinky[:face] = face
        @blinky[:status] = mode
        @blinky[:speed] = speed
      when @pinky
        @pinky[:face] = face
        @pinky[:status] = mode
        @pinky[:speed] = speed
      when @inky
        @inky[:face] = face
        @inky[:status] = mode
        @inky[:speed] = speed
      when @clyde
        @clyde[:face] = face
        @clyde[:status] = mode
        @clyde[:speed] = speed
    end
  end

  def reverse(char)
    char[:direction] = case char[:direction]
    when "left"
      "right" if @board[char[:y]][(char[:x] + 1) % @boardx] != @wall
    when "right"
      "left" if @board[char[:y]][(char[:x] - 1) % @boardx] != @wall
    when "up"
      "down" if @board[(char[:y] + 1) % @boardy][char[:x]] != @wall
    when "down"
      "up" if @board[(char[:y] - 1) % @boardy][char[:x]] != @wall
    else
      char[:direction]
    end
  end

  def pathFind(char, loc)
    if @running == true

      old_y = char[:y]
      old_x = char[:x]
      dir = char[:direction]
      mode = char[:status]
      @board[old_y][old_x] = char[:below]

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

      if [old_y, old_x] == [14, 14] && mode == "dead"
        mode = "idle"
        char[:speed] = 0
        new_y = old_y
        new_x = old_x
      end

      if [old_y, old_x] == [@y, @x] || [new_y, new_x] == [@y, @x]
        if mode == "frightened"
          mode = "dead"
          char[:face] = @ghost_dead
          consec_check
        elsif !(mode == "dead")
          @running = false
        end
      end

      tile = case [new_y, new_x]
      when [@blinky[:y], @blinky[:x]]
        @blinky[:below]
      when [@pinky[:y], @pinky[:x]]
        @pinky[:below]
      when [@clyde[:y], @clyde[:x]]
        @clyde[:below]
      when [@inky[:y], @inky[:x]]
        @inky[:below]
      when [@y, @x]
        @space
      else
        @board[new_y][new_x]
      end

      case char
      when @blinky
        @blinky[:y] = new_y
        @blinky[:x] = new_x
        @blinky[:direction] = new_dir
        @blinky[:below] = tile
        @blinky[:status] = mode
      when @inky
        @inky[:y] = new_y
        @inky[:x] = new_x
        @inky[:direction] = new_dir
        @inky[:below] = tile
        @inky[:status] = mode
      when @pinky
        @pinky[:y] = new_y
        @pinky[:x] = new_x
        @pinky[:direction] = new_dir
        @pinky[:below] = tile
        @pinky[:status] = mode
      when @clyde
        @clyde[:y] = new_y
        @clyde[:x] = new_x
        @clyde[:direction] = new_dir
        @clyde[:below] = tile
        @clyde[:status] = mode
      end

      return mode
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
      @energized = 0
      [@blinky, @inky, @pinky, @clyde].each do |ghost|
        @board[ghost[:y]][ghost[:x]] = ghost[:below]
      end
      @blinky = @defaults[:blinky].clone
      @pinky = @defaults[:pinky].clone
      @inky = @defaults[:inky].clone
      @clyde = @defaults[:clyde].clone
      @x = @defaults[:x]
      @y = @defaults[:y]
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

  def treat(count)
    if count <= 170 && @treat == 0
      @board[20][14] = @defaults[:candy]
      @fizzle_treat = (rand(1000).to_f/1000) + 9 + @timer
      @treat = 1
    end
    if count <= 70 && @treat == 1
      @board[20][14] = @defaults[:candy]
      @fizzle_treat = (rand(1000).to_f/1000) + 9 + @timer
      @treat = 2
    end
    @board[20][14] = @space if @timer > @fizzle_treat && @board[20][14] == @defaults[:candy]
  end

  def consec_check
    @score += (2**@consecutive) * 200
    @consecutive += 1
    @capture_all += 1 if @consecutive == 4
    @score += 12000 if @capture_all == 4
  end

  def draw
    @board[@blinky[:y]][@blinky[:x]] = @blinky[:face]
    @board[@pinky[:y]][@pinky[:x]] = @pinky[:face]
    @board[@inky[:y]][@inky[:x]] = @inky[:face]
    @board[@clyde[:y]][@clyde[:x]] = @clyde[:face]
    @board[@y][@x] = @pacman
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
    @count = 0
    @board.each do |y|
      y.each do |x|
        @count += 1 if x == @pellet
      end
    end
    [@blinky, @inky, @pinky, @clyde].each { |ghost| @count += 1 if ghost[:below] == @pellet }
    treat(@count)
    @error = "You win! Moving to the next round..." if @count == 0
    puts "Lives: #{@lives}"
    puts "Time: #{@timer.round}"
    puts "Score: #{@score}"
    puts "Pellets remaining: #{@count}"
    puts "Consecutive kills: #{@consecutive}"
    puts "Message: #{@error}"
    puts "Blinky: #{@blinky[:status]}, Pinky: #{@pinky[:status]}, Inky: #{@inky[:status]}, Clyde: #{@clyde[:status]}"
    puts "Energy: #{@energized}"
    system "stty raw -echo"
    gets if @count == 0
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
