class Game

  SPAWN_RATE = 100
  MAX_ENEMIES = 10
  STATS_GUI_WIDTH = 10
  LOGS_GUI_HEIGHT = 5

  def self.start
    Items.generate
    $world = []
    $time = 0
    $milli_tick = 0
    $npcs = []
    $drops = []
    $dungeon = []
    $fps = []
    $tick = 1
    Log.new
    make_dungeon
  end

  def self.run_time(time)
    (100 - time).times do |t|
      Creature.all.each do |creature|
        creature.move if $tick % (100 - creature.run_speed) == 0
      end if Creature.all
      $tick += 1
    end
    $level = Game.update_level
    Player.verify_stats
    $time += 1
  end

  def self.pause
    Game.input(true)
    binding.pry
  end

  def self.end
    Game.input(true)
    exit 0
  end

  def self.overlay_string(str, color, times, gui_width)
    new_str = []
    new_str << "\e[#{color}m"
    str = str[0..18] if str.length > 18
    padding = (gui_width - str.length - 1).times.map {' '}.join('')
    "#{str}#{padding}".split('').each_with_index do |char, pos|
      colorize = pos < times ? "" : "\e[100m"
      new_str << "#{colorize}#{char}"
    end
    new_str << "\e[100m"
    new_str.join('')
  end

  def self.input(bool=true)
    if bool == false
      system "stty -echo"
      STDIN.raw!
      STDIN.echo = false
    else
      system "stty echo"
      STDIN.echo = true
      STDIN.cooked!
    end
  end

  def self.draw(board=$level)
    spawn_creature if ($time % 20 == 0 && Creature.count < MAX_ENEMIES)
    Game.input(true)
    print "\e[100m"
    (board.first.length + STATS_GUI_WIDTH + 1).times {print "--"}
    puts " \rStats "
    # Should calculate the board first, then draw it all at once.
    i = 0
    while i < board.length
      print "|"
      STATS_GUI_WIDTH.times do |t|
        print "  "
      end
      print "|\e[0m"
      print board[i].join
      print "\e[100m|\r| "
      print draw_stats(i)
      i += 1
    end
    print "\e[100m"
    draw_logs(board)
    debugger_tools
    Game.input(false)
  end

  def self.debugger_tools
    fps = 1 / (Time.now.to_f - $milli_tick)
    $fps << fps
    $fps.shift while $fps.length > 50
    avg_fps = $fps.inject(:+).to_f / $fps.size
    puts "Time: #{$time}"
    puts "Player: #{Player.visible ? 'visible' : 'invisible'}"
    puts "Ticks: #{$tick}"
    puts "FPS: #{fps}"
    puts "Average FPS: #{avg_fps}"
    puts "Depth: #{Player.depth}"
    puts "Creatures left: #{Creature.count if Creature.all}"
    puts "My location: (#{Player.x}, #{Player.y})"
    creature_locations = Creature.all.map do |creature|
      "(#{creature.x}, #{creature.y})"
    end if Creature.all
    puts "Creature locations: #{creature_locations}"
  end

  def self.draw_stats(row)
    print "\e[30m"
    print case row
    when 0
      hp = (Player.health / Player.max_health.to_f) * 100.00
      max = ((hp / STATS_GUI_WIDTH.to_f) * 2.00).round
      color = case hp
      when 60..100 then 42
      when 30..60 then 43
      when 0..30 then 41
      else 7
      end
      overlay_string(" Health: #{Player.health}/#{Player.max_health}", color, max, STATS_GUI_WIDTH*2)
    when 1
      hp = (Player.mana / Player.max_mana.to_f) * 100.00
      max = ((hp / STATS_GUI_WIDTH.to_f) * 2.00).round
      color = case hp
      when 60..100 then 46
      when 20..60 then 104
      when 0..20 then 45
      else 7
      end
      overlay_string(" Mana: #{Player.mana}/#{Player.max_mana}", color, max, STATS_GUI_WIDTH*2)
    when 2
      hp = (Player.energy / Player.max_energy.to_f) * 100.00
      max = ((hp / STATS_GUI_WIDTH.to_f) * 2.00).round
      color = case hp
      when 60..100 then 43
      when 20..60 then 103
      when 0..20 then 47
      else 7
      end
      overlay_string(" Energy: #{Player.energy}/#{Player.max_energy}", color, max, STATS_GUI_WIDTH*2)
    when 3
      "Gold: #{Player.gold}"
    when 19
      " 1 2 3 4 5 6 7 8 9"
    when 20

    end
    puts "\e[100;37m"
  end

  def self.draw_logs(board)
    (board.first.length + STATS_GUI_WIDTH + 1).times {print "--"}
    print " \rLogs "
    puts
    i = 0
    logs = Log.retrieve(LOGS_GUI_HEIGHT)
    logs << nil while logs.length < LOGS_GUI_HEIGHT
    logs.reverse!
    while i < LOGS_GUI_HEIGHT
      print "|"
      (board.first.length + STATS_GUI_WIDTH).times do |t|
        print "  "
      end
      print " |\r|"
      print " #{logs[i][0..((board.first.length + STATS_GUI_WIDTH - 1)*2)]} ".color(:white, :black) if logs[i]
      puts "\e[100;37m"
      i += 1
    end
    (board.first.length + STATS_GUI_WIDTH + 1).times {print "--"}
    puts " \e[0m"
  end

  def self.use_stairs(direction)
    case direction
    when "UP"
      if $dungeon[Player.depth - 1]
        Player.depth -= 1
        Player.x += ($world[Player.depth + 1][:offset][:x] - $world[Player.depth][:offset][:x])
        Player.y += ($world[Player.depth + 1][:offset][:y] - $world[Player.depth][:offset][:y])

        $height = Dungeon.current.length
        $width = Dungeon.current.first.length
      end
    when "DOWN"
      Player.depth += 1
      if Dungeon.current
        Player.x += ($world[Player.depth - 1][:offset][:x] - $world[Player.depth][:offset][:x])
        Player.y += ($world[Player.depth - 1][:offset][:y] - $world[Player.depth][:offset][:y])

        $height = Dungeon.current.length
        $width = Dungeon.current.first.length
      else
        Game.make_dungeon($world[Player.depth - 1][:offset], {x: Player.x, y: Player.y})
      end
    end
  end

  def self.make_dungeon(offset={x: 0, y: 0}, player_coords={x: 0, y: 0})
    until (dungeon_up ||= false) && (dungeon_down ||= false)
      dungeon = Dungeon.new.build(300)
      flat_dungeon = dungeon.to_array.flatten
      dungeon_up = flat_dungeon.include?("< ") ? true : false
      dungeon_down = flat_dungeon.include?("> ") ? true : false
    end

    $dungeon[Player.depth] = dungeon.to_array

    populate_dungeon

    Player.x = dungeon.left.abs + 1
    Player.y = dungeon.top.abs + 1

    $world[Player.depth] ||= {}
    $world[Player.depth][:up] ||= []
    $world[Player.depth][:down] ||= []
    layer_offset = {
      x: (offset[:x] + player_coords[:x] - Player.x),
      y: (offset[:y] + player_coords[:y] - Player.y)
    }
    $world[Player.depth][:offset] = layer_offset

    $height = Dungeon.current.length
    $width = Dungeon.current.first.length

    $width.times do |y|
      Dungeon.current[0][y] = "▒ "
      Dungeon.current[$height - 1][y] = "▒ "
    end

    $height.times do |x|
      $width.times do |y|
        pixel = Dungeon.current[x][y].uncolor
        direction = case pixel
        when "<" then :up
        when ">" then :down
        end
        if direction
          $world[Player.depth][direction] << {
            x: x,
            y: y
          }
        end
      end
      Dungeon.current[x][0] = "▒ "
      Dungeon.current[x][$width] = "▒ "
    end

    $level = update_level
  end

  def self.run_dungeon_tests(num)
    time = Time.now.to_f
    count = 0
    print "\e[32m"
    num.times do |t|
      dungeon = Dungeon.new.build(300).to_array.flatten
      print dungeon.include?("< ") ? "." : (count+=1;"\e[31mF\e[32m")
      print dungeon.include?("> ") ? "." : (count+=1;"\e[31mF \e[32m")
    end
    puts "\e[0m"
    puts "Created #{num} dungeons. Took #{(Time.now.to_f - time).round(1)} seconds. There was #{count} failures."
  end

  def self.populate_dungeon
    MAX_ENEMIES.times do |t|
      spawn_creature
    end
    Dungeon.current.each_with_index do |y, ypos|
      y.each_with_index do |x, xpos|
        if rand(100) == 0 && !(Dungeon.current[ypos][xpos].is_unbreakable?)
          Gold.new({x: xpos, y: ypos, value: rand(1..3)})
          Dungeon.current[ypos][xpos] = "  "
        end
      end
    end
    sword = Items["Excalibur"]
    sword.depth = 1
    sword.x = 20
    sword.y = 20
    Dungeon.current[20][20] = "  "
  end

  def self.spawn_creature
    color = :red
    type = case Player.depth
    when 1..100 then %w( s r a b f ).sample
    else "x"
    end
    Creature.new(type, color).spawn
  end

  def self.update_level
    viewport_width = 41
    viewport_height = 21
    Player.seen[Player.depth] ||= []
    # $level = Array.new (Dungeon.current.length) {Array.new(Dungeon.current.first.count) {"  "}}
    $level = Array.new (viewport_height) {Array.new(viewport_width) {"  "}}
    x_offset = Player.x - (viewport_width / 2)
    y_offset = Player.y - (viewport_height / 2)
    x_offset = x_offset < 0 ? 0 : x_offset
    y_offset = y_offset < 0 ? 0 : y_offset
    x_offset = x_offset > ($width - viewport_width + 1) ? ($width - viewport_width + 1) : x_offset
    y_offset = y_offset > ($height - viewport_height) ? ($height - viewport_height) : y_offset

    # Do not do circle code unless dungeon == dark
    # Check distance between all enemies. If in radius, then draw them
    # Only do 1 calculation.

    viewport = []
    Player.seen[Player.depth].each do |see|
      in_x = (see[:x] >= x_offset) && (see[:x] < x_offset + viewport_width)
      in_y = (see[:y] >= y_offset) && (see[:y] < y_offset + viewport_height)
      viewport << {x: see[:x], y: see[:y]} if in_x && in_y
    end
    viewport.each do |seen|
      # This makes what the Player has previously seen gray.
      pixel = Dungeon.current[seen[:y]][seen[:x]]
      $level[seen[:y] - y_offset][seen[:x] - x_offset] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
    end
    visible = Visible.new(Dungeon.current, {x: Player.x, y: Player.y}, Player.vision_radius).find_visible
    visible.each do |in_sight|
      Player.seen[Player.depth] << in_sight
        # This makes the current visibility white.
      if Dungeon.current[in_sight[:y]][in_sight[:x]] == "  "
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = ". "
      else
        floor = Dungeon.current[in_sight[:y]][in_sight[:x]]
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = floor
      end
      Gold.all.each do |gold|
        if gold.x == in_sight[:x] && gold.y == in_sight[:y]
          $level[gold.y - y_offset][gold.x - x_offset] = Gold.show
        end
      end
      Items.on_board.each do |item|
        if item.coords
          if item.x == in_sight[:x] && item.y == in_sight[:y]
            $level[item.y - y_offset][item.x - x_offset] = item.show
          end
        end
      end
      Creature.all.each do |creature|
        if creature.x == in_sight[:x] && creature.y == in_sight[:y]
          $level[creature.y - y_offset][creature.x - x_offset] = creature.show
        end
      end if Creature.all
    end
    $level[Player.y - y_offset][Player.x - x_offset] = Player.show
    $level
  end
end
