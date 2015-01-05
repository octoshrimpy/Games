##-- Structure
# init
# build
# tick
# movement
# draw
# died
# scoreCheck

##-- Game Play
# movePacman
# moveGhost

##-- Supportive
# pathFind
# timerControl

##-- Changes
# score
# treat
# checkConsecutive
# nextRound
# createMessage
# deleteMessage

##-- Logic - Returns values
# rangeMapper*
# speedControl
# reverse
# directionalDistances
# distanceTo*

require 'io/console'
require 'io/wait'
class Pacman
# ------------------------- Structure --------------------
  def initialize
    File.new "./Saves/pacman.txt", "w+" if !(File.exists?("./Saves/pacman.txt"))
    @highscore = File.read("./Saves/pacman.txt").to_i

    t = Time.now
    @time1 = t
    @time2 = t

    @space = "  "
    @level = 1
    @dots = 240

    @frame_count = 0
    @frame_rate = 0
    @fps = 0

    @countdown = {
      candy: t,
      energy: t,
      message: t
    }
    @defaults = {
      wall: "[]",
      blinky: {
        y: 14,
        x: 14,
        target: [1, 25],
        origin: [17, 14],
        direction: "left",
        below: @space,
        face: "Ω ",
        status: "idle",
        last_move: t,
        wait: 0
      },
      pinky: {
        y: 17,
        x: 14,
        target: [1, 2],
        origin: [17, 14],
        direction: "left",
        below: @space,
        face: "¥ ",
        status: "idle",
        last_move: t,
        wait: 0
      },
      inky: {
        y: 17,
        x: 13,
        target: [35, 27],
        origin: [17, 13],
        direction: "left",
        below: @space,
        face: "∑ ",
        status: "idle",
        last_move: t,
        wait: 0
      },
      clyde: {
        y: 17,
        x: 15,
        target: [35, 0],
        origin: [17, 15],
        direction: "left",
        below: @space,
        face: "∆ ",
        status: "idle",
        last_move: t,
        wait: 0
      },
      pacman: {
        still: "o ",
        open_left: "> ",
        open_right: " <",
        open_up: "v ",
        open_down: "^ ",
        closed_vert: "| ",
        closed_right: " -",
        closed_left: "- ",
        face: "o ",
        status: "active",
        x: 14,
        y: 26,
        last_move: t,
        next_dir: 3,
        dir: 0,
        energized: false
      },
      pellet: ". ",
      space: @space,
      energy: "ø ",
      energy_swollen: "Ø ",
      candy: "å ",
      scared: "† ",
      blink: "• ",
      ghost_dead: "ºº",
      door: "__",
      width: 28,
      height: 37
    }

    @boardy = @defaults[:height]
    @boardx = @defaults[:width]
    @wall = @defaults[:wall]
    @pellet = @defaults[:pellet]
    @extra_life_given = false
    @door = @defaults[:door]
    @board = Array.new(@boardy) {Array.new(@boardx) {@pellet}}
    @energy = []
    [6, 26].each do |blocks|
      [1, 26].each do |block|
        @energy << [blocks, block]
      end
    end
    @energy_face = @defaults[:energy]

    @lives = 2
    @running = true
    @even = true
    @score = 0
    @stop = 0
    @timer = 0.00
    @offset = 0
    @count = 1
    @treat = 0
    @consecutive = 0
    @capture_all = 0

    @dead_ghost = @defaults[:ghost_dead]
    @scared = @defaults[:scared]
    @blinky = @defaults[:blinky].clone
    @inky = @defaults[:inky].clone
    @pinky = @defaults[:pinky].clone
    @clyde = @defaults[:clyde].clone
    @pacman = @defaults[:pacman].clone
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
        ((4..31).to_a - [8, 14, 16, 17, 18, 20, 26]).each do |blocks|
          [0, 13, 14, 27].each do |block|
            @board[blocks][block] = @wall
          end
        end
        [5, 6, 7, 24, 25].each do |blocks|
          ((2..25).to_a - [6, 12, 13, 14, 15, 21]).each do |block|
            @board[blocks][block] = @wall
          end
        end
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
        @board[15][13] = @board[15][14] = @door
        [13, 14, 15, 19, 20, 21].each do |blocks|
          [0, 27].each do |block|
            @board[blocks][block] = @space
          end
        end
        @board[26][13] = @space #Next to Pacman
        (12..22).each do |blocks|
          @board[blocks].each_with_index do |x, block|
            @board[blocks][block] = @space if @board[blocks][block] == @pellet && !([6, 21].include?(block))
          end
        end
        @board[33][x] = @wall
        @board[y][x] = @space if y > 33
        if !([@space, @wall, @pellet, @energy_face].include?(@board[y][x])) && y != 2
          @board[y][x] = @space
        end
      end
    end
  end

  def tick
    if @running == true
      change = false
      old_time = @timer
      t = Time.now
      change = timerControl(t)
      seconds = @timer - @offset

      [@pacman, @blinky, @pinky, @inky, @clyde].each do |ghost|
        if t > ghost[:last_move] + 1.to_f/rangeMapper(0, 100, 0, 9, speedControl(ghost))
          ghost[:last_move] = t
          ghost == @pacman ? movePacman : moveGhost(ghost, seconds)
          change = true
        end
      end

      draw if change == true
    else
      died
    end
  end

  def movement(m)
    m = m[0]
    @pacman[:next_dir] = 1 if m == "d"
    @pacman[:next_dir] = 2 if m == "s"
    @pacman[:next_dir] = 3 if m == "a"
    @pacman[:next_dir] = 4 if m == "w"
    if m == "x"
      @running = false
      scoreCheck
    end
  end

  def draw
    @board[@blinky[:y]][@blinky[:x]] = @blinky[:face]
    @board[@pinky[:y]][@pinky[:x]] = @pinky[:face]
    @board[@inky[:y]][@inky[:x]] = @inky[:face]
    @board[@clyde[:y]][@clyde[:x]] = @clyde[:face]
    @board[@pacman[:y]][@pacman[:x]] = @pacman[:face]
    @energy.each { |loc| @board[loc[0]][loc[1]] = @energy_face }
    system "stty -raw echo"
    system "clear" or system "cls"
    print "FPS: #{@fps}     "
    puts "Highscore: #{@highscore}"
    puts "Score: #{@score}"
    i = 0
    while i < @board.length
      if i > 2 && i < 34
        print i
        print " "
        print " " if i < 10
      end
      @board[i][@board[i].index(nil)] = @space if @board[i].include?(nil)
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
    nextRound if @count == 0
    @lives.times { print ">  " }
    puts ""
    puts "Time: #{@timer.round}"
    puts "Level: #{@level}"
    puts "Eaten: #{240 - @count}"
    system "stty raw -echo"
  end

  def died
    if @lives > 0
      @lives -= 1
      @running = true
      @stop = 0
      @offset = @timer
      @countdown.each { |obj, val| @countdown[obj] = Time.now - 15 }
      [@blinky, @inky, @pinky, @clyde].each do |ghost|
        @board[ghost[:y]][ghost[:x]] = ghost[:below]
      end
      @blinky = @defaults[:blinky].clone
      @pinky = @defaults[:pinky].clone
      @inky = @defaults[:inky].clone
      @clyde = @defaults[:clyde].clone
      @pacman = @defaults[:pacman].clone
      build
      createMessage("Get Ready!")
    else
      puts "Frames: #{@frame_count}"
      scoreCheck
    end
  end

  def scoreCheck
    system "stty -raw echo"
    if @score > @highscore
      new_score = @score
      puts "You have beaten the high score!"
      File.open("./Saves/pacman.txt", 'w+') { |f| f.puts("#{new_score}") }
    end
    exit
  end
# ------------------------- Game Play --------------------
  def movePacman
    @board[@pacman[:y]][@pacman[:x]] = @space
    if @stop == 0
      case @pacman[:next_dir]
      when 1
        @pacman[:dir] = @pacman[:next_dir] if @board[@pacman[:y]][((@pacman[:x] + 1) % @boardx)] != @wall && @board[@pacman[:y]][((@pacman[:x] + 1) % @boardx)] != @door
      when 2
        @pacman[:dir] = @pacman[:next_dir] if @board[((@pacman[:y] + 1) % @boardy)][@pacman[:x]] != @wall && @board[((@pacman[:y] + 1) % @boardy)][@pacman[:x]] != @door
      when 3
        @pacman[:dir] = @pacman[:next_dir] if @board[@pacman[:y]][((@pacman[:x] - 1) % @boardx)] != @wall && @board[@pacman[:y]][((@pacman[:x] - 1) % @boardx)] != @door
      when 4
        @pacman[:dir] = @pacman[:next_dir] if @board[((@pacman[:y] - 1) % @boardy)][@pacman[:x]] != @wall && @board[((@pacman[:y] - 1) % @boardy)][@pacman[:x]] != @door
      end
      case @pacman[:dir]
      when 1
        @board[@pacman[:y]][((@pacman[:x] + 1) % @boardx)] != @wall && @board[@pacman[:y]][((@pacman[:x] + 1) % @boardx)] != @door ? @pacman[:x] = (@pacman[:x] + 1) % @boardx : @pacman[:dir] = @pacman[:next_dir]
      when 2
        @board[((@pacman[:y] + 1) % @boardy)][@pacman[:x]] != @wall && @board[((@pacman[:y] + 1) % @boardy)][@pacman[:x]] != @door ? @pacman[:y] = (@pacman[:y] + 1) % @boardy : @pacman[:dir] = @pacman[:next_dir]
      when 3
        @board[@pacman[:y]][((@pacman[:x] - 1) % @boardx)] != @wall && @board[@pacman[:y]][((@pacman[:x] - 1) % @boardx)] != @door ? @pacman[:x] = (@pacman[:x] - 1) % @boardx : @pacman[:dir] = @pacman[:next_dir]
      when 4
        @board[((@pacman[:y] - 1) % @boardy)][@pacman[:x]] != @wall && @board[((@pacman[:y] - 1) % @boardy)][@pacman[:x]] != @door ? @pacman[:y] = (@pacman[:y] - 1) % @boardy : @pacman[:dir] = @pacman[:next_dir]
      end
    else
      @stop -= 1
    end

    location = @board[@pacman[:y]][@pacman[:x]]
    location = @space if location == nil
    ghost_locations = [[@blinky[:y], @blinky[:x]], [@pinky[:y], @pinky[:x]], [@clyde[:y], @clyde[:x]], [@inky[:y], @inky[:x]]]
    if location == @pellet
      score('pellet')
    elsif location == @defaults[:candy]
      score('candy')
    elsif @energy_face.include?(location)
      score('energy')
    elsif ghost_locations.include?([@pacman[:y], @pacman[:x]])
      enemy = case ghost_locations.index([@pacman[:y], @pacman[:x]])
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

        checkConsecutive
      end
    end

    @even = (((@timer.round(1)*10)/2)%2).floor == 0 ? true : false
    if @even == true
      @pacman[:face] = case @pacman[:dir]
      when 0
        @pacman[:still]
      when 3
        @pacman[:closed_left]
      when 1
        @pacman[:closed_right]
      when 2, 4
        @pacman[:closed_vert]
      end
      @energy_face = @defaults[:energy_swollen]
    else
      @energy_face = @defaults[:energy]
      @pacman[:face] = case @pacman[:dir]
      when 0
        @pacman[:still]
      when 1
        @pacman[:open_right]
      when 2
        @pacman[:open_down]
      when 3
        @pacman[:open_left]
      when 4
        @pacman[:open_up]
      end
    end
    [@blinky, @inky, @pinky, @clyde].each do |ghost|
      if (@countdown[:energy] - Time.now).to_i < 2 && ghost[:status] == "frightened"
        ghost[:face] = @even == true ? @defaults[:scared] : @defaults[:blink]
      end
    end
  end

  def moveGhost(me, seconds)
    face = me[:face]
    mode = me[:status]

    defaults = case me
    when @blinky
      @defaults[:blinky]
    when @pinky
      @pinky[:wait] = 3 if seconds < 2
      @defaults[:pinky]
    when @inky
      @inky[:wait] = 3 if seconds < 8
      @defaults[:inky]
    when @clyde
      @clyde[:wait] = 3 if seconds < 21
      @defaults[:clyde]
    end

    if mode == "frightened"
      if @pacman[:energized] == false
        face = defaults[:face]
        me[:status] = mode = "idle"
      else
        face = @scared
      end
    end
    if !(mode == "frightened" || mode == "dead")
      if seconds < 7 || (seconds > 27 && seconds < 34) || (seconds > 54 && seconds < 61) || (seconds > 48 && seconds < 55)
        reverse(me) if mode == "chase"
        me[:status] = "scatter"
      else
        reverse(me) if mode == "scatter"
        me[:status] = "chase"
      end
    end

    mode = case me[:status]
      when "scatter"
        face = defaults[:face]
        pathFind(@blinky, @blinky[:target]) if me == @blinky
        pathFind(@pinky, @pinky[:target]) if me == @pinky
        pathFind(@inky, @inky[:target]) if me == @inky
        pathFind(@clyde, @clyde[:target]) if me == @clyde
      when "chase"
        face = defaults[:face]
        if me == @blinky
          speed = 37
          pathFind(@blinky, [@pacman[:y], @pacman[:x]])
        end
        if me == @pinky
          case @pacman[:dir]
          when 1
            pathFind(@pinky, [@pacman[:y], (@pacman[:x] + 4) % @boardx])
          when 2
            pathFind(@pinky, [(@pacman[:y] + 4) % @boardy, @pacman[:x]])
          when 3
            pathFind(@pinky, [@pacman[:y], (@pacman[:x] - 4) % @boardx])
          when 4
            pathFind(@pinky, [(@pacman[:y] - 4) % @boardy, @pacman[:x]])
          else
            pathFind(@pinky, [@pacman[:y], @pacman[:x]])
          end
        end
        if me == @inky
          vector = distanceTo([@blinky[:y], @blinky[:x]], [@pacman[:y], @pacman[:x]], 2)
          pathFind(@inky, [@blinky[:y]+vector[0], @blinky[:x]+vector[1]])
        end
        if me == @clyde
          dist = distanceTo([@clyde[:y], @clyde[:x]], [@pacman[:y], @pacman[:x]])
          if (dist[0].abs + dist[1].abs) >= 8
            pathFind(@clyde, [@pacman[:y], @pacman[:x]])
          else
            pathFind(@clyde, @clyde[:target])
          end
        end
      when "frightened"
        face = @scared
        pathFind(me, [rand(@boardy), rand(@boardx)])
      when "dead"
        face = @dead_ghost
        pathFind(me, me[:origin])
      when "idle"
        face = "x "
        "idle"
    end

    case me
      when @blinky
        @blinky[:face] = face
        @blinky[:status] = mode
      when @pinky
        @pinky[:face] = face
        @pinky[:status] = mode
      when @inky
        @inky[:face] = face
        @inky[:status] = mode
      when @clyde
        @clyde[:face] = face
        @clyde[:status] = mode
    end
  end
# ------------------------- Supportive -------------------
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

      distances = directionalDistances(new_y, new_x, char, loc)

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

      if [old_y, old_x] == char[:origin] && mode == "dead"
        mode = "idle"
        char[:wait] = 10
        new_y = old_y
        new_x = old_x
      end

      if char[:wait] > 0
        char[:wait] -= 1
        if char[:wait] == 0
          new_x = new_y = 14
          new_dir = "left"
        end
      end

      if [old_y, old_x] == [@pacman[:y], @pacman[:x]] || [new_y, new_x] == [@pacman[:y], @pacman[:x]]
        if mode == "frightened"
          ghosts = [@blinky, @inky, @inky, @clyde]
          ghosts.each do |ghost|
            if [ghost[:y], ghost[:x]] == [char[:y], char[:x]]
              ghost[:status] = "dead"
              ghost[:face] = @ghost_dead
            end
          end
          mode = "dead"
          char[:face] = @ghost_dead
          checkConsecutive
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
      when [@pacman[:y], @pacman[:x]]
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

  def timerControl(t)
    delta = 0
    if @time1 > @time2
      @time2 = t
      delta = @time2 - @time1 if @time2 - @time1 < 3
    else
      @time1 = t
      delta = @time1 - @time2 if @time1 - @time2 < 3
    end
    @frame_count += 1
    @frame_rate += 1
    @timer += delta.round(5)
    @timer = @timer.round(5)

    @countdown.each do |obj, val|
      if val < t
        case obj
        when :message
          deleteMessage
        when :candy
          @board[20][14] = @space if @board[20][14] == @defaults[:candy]
        when :energy
          @pacman[:energized] = false
        end
      end
    end

    if old_time.round != @timer.round
      @fps = @frame_rate
      @frame_rate = 0
      change = true
    end
    change ||= false
  end
# -------------------------- Changes ---------------------
  def score(str)
    score = 0
    case str
    when 'pellet'
      @score += 10
    when 'energy'
      @consecutive = 0
      @stop += 1
      score = 50
      @pacman[:energized] = true
      time = case @level
      when 1
        6
      when 2, 6, 10
        5
      when 3
        4
      when 4, 14
        3
      when 5, 7, 8, 11
        2
      when 9, 12, 13, 15, 16, 18
        1
      else
        0
      end
      @countdown[:energy] = Time.now + time
      [@blinky, @inky, @pinky, @clyde].each do |ghost|
        reverse(ghost)
        ghost[:status] = "frightened" if ghost[:status] != "dead"
      end
      @energy -= [[@pacman[:y], @pacman[:x]]]
    when 'candy'
      score = case @level
      when 1
        100
      when 2
        300
      when 3, 4
        500
      when 5, 6
        700
      when 7, 8
        1000
      when 9, 10
        2000
      when 11, 12
        3000
      else
        5000
      end
    else
      score = str
    end
    @score += score
    if @score >= 10000 && @extra_life_given == false
      @extra_life_given = true
      @lives += 1
    end
    createMessage(score, false) if score > 0
  end

  def treat(count)
    if count <= 170 && @treat == 0
      @board[20][14] = @defaults[:candy]
      @countdown[:candy] = Time.at((rand(1000).to_f/1000) + 9 + Time.now.to_i)
      @treat = 1
    end
    if count <= 70 && @treat == 1
      @board[20][14] = @defaults[:candy]
      @countdown[:candy] = Time.at((rand(1000).to_f/1000) + 9 + Time.now.to_i)
      @treat = 2
    end
  end

  def checkConsecutive
    score((2**@consecutive) * 200)
    @consecutive += 1
    @capture_all += 1 if @consecutive == 4
    score(12000) if @capture_all == 4
  end

  def nextRound
    @level += 1
    @treat = 0
    @running = true
    @stop = 0
    @offset = @timer
    @energy = []
    [6, 26].each do |blocks|
      [1, 26].each do |block|
        @energy << [blocks, block]
      end
    end
    @countdown.each { |obj, val| @countdown[obj] = Time.now - 15 }
    [@blinky, @inky, @pinky, @clyde].each do |ghost|
      @board[ghost[:y]][ghost[:x]] = ghost[:below]
    end
    @blinky = @defaults[:blinky].clone
    @pinky = @defaults[:pinky].clone
    @inky = @defaults[:inky].clone
    @clyde = @defaults[:clyde].clone
    @pacman = @defaults[:pacman].clone
    @board = Array.new(@boardy) {Array.new(@boardx) {@pellet}}
    build
    createMessage("Get Ready!")
  end

  def createMessage(msg, pause=true)
    deleteMessage
    ghost_locations = [[@blinky[:y], @blinky[:x]], [@pinky[:y], @pinky[:x]], [@clyde[:y], @clyde[:x]], [@inky[:y], @inky[:x]]]
    retrieve = []
    error = msg.to_s.split("")
    start = error.length/2
    error.each_with_index do |letter, pos|
      retrieve << @board[20][(14 - start) + pos]
      if msg == "Get Ready!"
        @board[20][(14 - start) + pos] = letter + " "
      else
        if ghost_locations.include?([17, (14 - start) + pos])
          ghost = case [17, (14 - start) + pos]
          when [@blinky[:y], @blinky[:x]]
            @blinky
          when [@pinky[:y],@pinky[:x]]
            @pinky
          when [@inky[:y], @inky[:x]]
            @inky
          when [@clyde[:y], @clyde[:x]]
            @clyde
          end
          ghost[:below] = letter + " "
        end
        @board[17][(14 - start) + pos] = letter + " "
      end
    end
    draw
    if pause == true
      sleep(3)
      deleteMessage
    else
      @countdown[:message] = Time.now + 3
    end
  end

  def deleteMessage
    (9..18).each do |pos|
      @board[20][pos] = @space if @board[20][pos] != @defaults[:candy]
    end
    (11..16).each do |pos|
      @board[17][pos] = @space
    end
  end
# --------------------------- Logic ----------------------
  def rangeMapper(from_min, from_max, to_min, to_max, value)
    ((to_max - to_min) * (value - from_min)) / (from_max - from_min) + to_min
  end

  def speedControl(who)
    speed = 0
    mode = who[:status]
    tunnel = []
    ((0..5).to_a + (22..27).to_a).each { |x| tunnel << [17, x]}
    if who == @pacman
      speed = case @level
      when 1
        @pacman[:energized] == false ? 80 : 85
      when (2..4)
        @pacman[:energized] == false ? 90 : 95
      when (5..20)
        100
      else
        10
      end
    elsif who == @blinky
      case @level
      when 1
        speed = 75
        if who == @blinky
          speed = 80 if @count < 20
          speed = 85 if @count < 10
        end
        speed = 45 if tunnel.include?([who[:y], who[:x]])
      when 2
        speed = 85
        if who == @blinky
          speed = 90 if @count < 30
          speed = 95 if @count < 15
        end
        speed = 45 if tunnel.include?([who[:y], who[:x]])
      when 3, 4
        speed = 85
        if who == @blinky
          speed = 90 if @count < 40
          speed = 95 if @count < 20
        end
        speed = 45 if tunnel.include?([who[:y], who[:x]])
      when 5
        speed = 95
        if who == @blinky
          speed = 100 if @count < 40
          speed = 105 if @count < 20
        end
        speed = 45 if tunnel.include?([who[:y], who[:x]])
      when (6..8)
        speed = 95
        if who == @blinky
          speed = 100 if @count < 50
          speed = 105 if @count < 25
        end
        speed = 50 if tunnel.include?([who[:y], who[:x]])
      when (9..11)
        speed = 95
        if who == @blinky
          speed = 100 if @count < 60
          speed = 105 if @count < 30
        end
        speed = 50 if tunnel.include?([who[:y], who[:x]])
      when (12..14)
        speed = 95
        if who == @blinky
          speed = 100 if @count < 80
          speed = 105 if @count < 40
        end
        speed = 50 if tunnel.include?([who[:y], who[:x]])
      when (15..18)
        speed = 95
        if who == @blinky
          speed = 100 if @count < 100
          speed = 105 if @count < 50
        end
        speed = 50 if tunnel.include?([who[:y], who[:x]])
      end
    else
      case @level
      when 1
        speed = 75
        speed = 40 if tunnel.include?([who[:y], who[:x]])
      when (2..4)
        speed = 85
        speed = 45 if tunnel.include?([who[:y], who[:x]])
      else
        speed = 95
        speed = 50 if tunnel.include?([who[:y], who[:x]])
      end
    end
    if mode == "frightened"
      speed = case @level
      when 1
        50
      when (2..4)
        55
      else
        60
      end
    end
    speed = 95 if mode == "dead"
    return speed
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

  def directionalDistances(new_y, new_x, char, loc)
    mode = char[:status]
    dir = char[:direction]

    up = [((new_y - 1) % @boardy), new_x]
    left = [new_y, ((new_x - 1) % @boardx)]
    down = [((new_y + 1) % @boardy), new_x]
    right = [new_y, ((new_x + 1) % @boardx)]
    distances = []
    [up, left, down, right].each do |pos|
      taken = @board[pos[0]][pos[1]]
      old = [new_y, new_x]
      if mode != "dead" && mode != "frightened"
        bad_loc = [[14, 12], [14, 15], [26, 12], [26, 15]]
      else
        bad_loc = []
      end
      valid = true
      valid = false if (dir == "down" || bad_loc.include?(old)) && pos == up
      valid = false if pos == down && dir == "up"
      valid = false if pos == right && dir == "left"
      valid = false if pos == left && dir == "right"
      if taken != @wall && valid && (taken != @door || mode == "dead")
        dist = distanceTo(pos, loc)
        distances << (dist[0].abs**2 + dist[1].abs**2)**(1.00/2)
      else
        distances << 10000
      end
    end
    return distances
  end

  def distanceTo(from, to, multiplier=1)
    [((to[0] - from[0])*multiplier), ((to[1] - from[1])*multiplier)]
  end
end

game = Pacman.new
game.build
game.createMessage("Get Ready!")

prompt = Thread.new do
  loop do
    game.movement(s = STDIN.getch.downcase)
  end
end

loop do
  game.tick
end
