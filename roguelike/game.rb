class Game

  SPAWN_RATE = 100
  MAX_ENEMIES = 10
  STATS_GUI_WIDTH = 10
  LOGS_GUI_HEIGHT = 5
  VIEWPORT_WIDTH = 41
  VIEWPORT_HEIGHT = 21

  def self.start
    $seed = 40.times.map {|a| (rand_seed ||= Random.new_seed.to_s)[a] ? rand_seed[a] : 1}.join
    srand($seed.to_i)
    Item.generate
    $message = "Welcome! Press '#{$key_open_help}' at any time to view how to play."
    $previous_message = ''
    $gamemode = "play"
    $spawn_creatures = true
    $screen_shot = nil
    $world = []
    $time = 0
    $milli_tick = 0
    $npcs = []
    $drops = []
    $dungeon = []
    $fps = []
    $tick = 1
    $visible_calculations = 0
    $sleep_condition = ''
    Log.new
    Log.add "Welcome to the game!"
    make_dungeon
  end

  def self.run_time(time)
    (100 - time).times do |t|
      Creature.all.each do |creature|
        creature.move if $tick % (100 - creature.run_speed) == 0
      end if Creature.all
      $tick += 1
    end
    Player.invisibility_ticks -= 1
    Player.verify_stats
    $time += 1
  end

  def self.redraw
    $level = Game.update_level
    Game.draw
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

  def self.show(coords=Player.coords)
    board = Array.new (VIEWPORT_HEIGHT) {Array.new(VIEWPORT_WIDTH) {"  "}}

    x_offset = coords[:x] - (VIEWPORT_WIDTH / 2)
    y_offset = coords[:y] - (VIEWPORT_HEIGHT / 2)
    x_offset = x_offset < 0 ? 0 : x_offset
    y_offset = y_offset < 0 ? 0 : y_offset
    x_offset = x_offset > ($width - VIEWPORT_WIDTH + 1) ? ($width - VIEWPORT_WIDTH + 1) : x_offset
    y_offset = y_offset > ($height - VIEWPORT_HEIGHT) ? ($height - VIEWPORT_HEIGHT) : y_offset

    $screen_shot_visible_coords

    get_screen_shot.each_with_index do |row, y|
      row.each_with_index do |pixel, x|
        in_x = (x >= x_offset) && (x < x_offset + VIEWPORT_WIDTH)
        in_y = (y >= y_offset) && (y < y_offset + VIEWPORT_HEIGHT)
        if in_x && in_y
          pixel = if $screen_shot_visible.include?({x: x, y: y})
            pixel.color(:white)
          else
            pixel.color(:light_black)
          end
          if y == coords[:y] && x == coords[:x]
            $message = Game.describe(pixel, coords)
            pixel = "#{pixel.uncolor[0]}#{'<'}".color(:white, :blue)
          end
          board[y - y_offset][x - x_offset] = pixel
        end
      end
    end

    $screen_shot_objects.each do |obj|
      in_x = (obj[:x] >= x_offset) && (obj[:x] < x_offset + VIEWPORT_WIDTH)
      in_y = (obj[:y] >= y_offset) && (obj[:y] < y_offset + VIEWPORT_HEIGHT)
      if in_x && in_y
        pixel = if {y: obj[:y], x: obj[:x]} == coords
          "#{obj[:instance].show.uncolor[0]}#{'<'}".color(:white, :blue)
        else
          obj[:instance].show
        end
        board[obj[:y] - y_offset][obj[:x] - x_offset] = pixel
      end
    end

    Game.draw(board)
    puts "Looking at: (#{coords[:x]}, #{coords[:y]})"
  end

  def self.draw(board=$level)
    Player.verify_stats
    system 'clear' or system 'cls'
    if Creature.all && Creature.count == 0 && $spawn_creatures == true
      $spawn_creatures = false
      Log.add "You have eradicated all forms of life on this floor."
    end
    spawn_creature if ($time % SPAWN_RATE == 0 && Creature.count < MAX_ENEMIES && $spawn_creatures == true)
    Game.input(true)
    print "\e[100m"
    (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "  "}
    print "|\r|"
    message_title = "Message"
    half_way_mark = (STATS_GUI_WIDTH - (message_title.length/2))/2
    half_way_mark.times {print "--"}
    print "-#{message_title}"
    half_way_mark.times {print "--"}
    if $message.length > 0
      print " #{$message[0..(VIEWPORT_WIDTH*2 - 7)].gsub("\n", " ")}"
      print "...(#{$key_read_more})" if $message.length > (VIEWPORT_WIDTH*2 - 7)
      $previous_message = $message.clone
      $message = ""
    end
    puts
    (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "--"}
    puts " \rStats "
    # Should calculate the board first, then draw it all at once.
    VIEWPORT_HEIGHT.times do |i|
      print "|"
      STATS_GUI_WIDTH.times do |t|
        print "  "
      end
      print "|\e[0m"
      print board[i].join
      print "\e[100m|\r| "
      print draw_stats(i)
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
    puts "Player: #{Player.visible ? 'visible' : 'invisible for ' + (Player.invisibility_ticks - 1).to_s}"
    puts "Ticks: #{$tick}"
    puts "FPS: #{fps}"
    puts "Average FPS: #{avg_fps}"
    puts "Depth: #{Player.depth}"
    puts "Creatures left: #{Creature.count if Creature.all}"
    puts "My location: (#{Player.x}, #{Player.y})"
    puts "Vision Calculations: #{$visible_calculations}"
    $visible_calculations = 0
    print "Creature locations: "
    Creature.all.each do |creature|
      print " (#{creature.x}, #{creature.y}) "
    end if Creature.all
    puts
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
    (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "--"}
    print " \rLogs "
    puts
    i = 0
    logs = Log.retrieve(LOGS_GUI_HEIGHT)
    logs << nil while logs.length < LOGS_GUI_HEIGHT
    logs.reverse!
    while i < LOGS_GUI_HEIGHT
      print "|"
      (VIEWPORT_WIDTH + STATS_GUI_WIDTH).times do |t|
        print "  "
      end
      print " |\r|"
      print " #{logs[i][0..((VIEWPORT_WIDTH + STATS_GUI_WIDTH - 1)*2)]} ".color(:white, :black) if logs[i]
      puts "\e[100;37m"
      i += 1
    end
    (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "--"}
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
        $spawn_creatures = true
        spawn_creature
      end
    when "DOWN"
      Player.depth += 1
      if Dungeon.current
        Player.x += ($world[Player.depth - 1][:offset][:x] - $world[Player.depth][:offset][:x])
        Player.y += ($world[Player.depth - 1][:offset][:y] - $world[Player.depth][:offset][:y])

        $height = Dungeon.current.length
        $width = Dungeon.current.first.length
        $spawn_creatures = true
        spawn_creature
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
        unless Dungeon.current[ypos][xpos].is_unbreakable? || rand(100) > 0
          Gold.new({x: xpos, y: ypos, value: rand(1..3)})
          Game.input true; binding.pry if ypos == 0
          Dungeon.current[ypos][xpos] = "  "
        end
      end
    end
    sword = Item["Rusty Dagger"]
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
    Player.seen[Player.depth] ||= []
    $level = Array.new (VIEWPORT_HEIGHT) {Array.new(VIEWPORT_WIDTH) {"  "}}
    x_offset = Player.x - (VIEWPORT_WIDTH / 2)
    y_offset = Player.y - (VIEWPORT_HEIGHT / 2)
    x_offset = x_offset < 0 ? 0 : x_offset
    y_offset = y_offset < 0 ? 0 : y_offset
    x_offset = x_offset > ($width - VIEWPORT_WIDTH + 1) ? ($width - VIEWPORT_WIDTH + 1) : x_offset
    y_offset = y_offset > ($height - VIEWPORT_HEIGHT) ? ($height - VIEWPORT_HEIGHT) : y_offset

    # Do not do circle code unless dungeon == dark
    # Check distance between all enemies. If in radius, then draw them
    # Only do 1 calculation.

    viewport = []
    Player.seen[Player.depth].each do |see|
      in_x = (see[:x] >= x_offset) && (see[:x] < x_offset + VIEWPORT_WIDTH)
      in_y = (see[:y] >= y_offset) && (see[:y] < y_offset + VIEWPORT_HEIGHT)
      viewport << {x: see[:x], y: see[:y]} if in_x && in_y
    end
    viewport.each do |seen|
      # This makes what the Player has previously seen gray.
      pixel = Dungeon.current[seen[:y]][seen[:x]]
      $level[seen[:y] - y_offset][seen[:x] - x_offset] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
    end
    find_currently_visible(x_offset, y_offset)
    $level
  end

  def self.find_currently_visible(x_offset, y_offset)
    visible = Visible.new(Dungeon.current, {x: Player.x, y: Player.y}, Player.vision_radius).find_visible
    visible.each do |in_sight|
      Player.seen[Player.depth] << in_sight unless Player.seen[Player.depth].include?(in_sight)
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
      end if Gold.all
      Item.on_board.each do |item|
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
  end

  def self.get_screen_shot
    return $screen_shot if $screen_shot
    $screen_shot = []
    $screen_shot_objects = []
    $screen_shot_visible = []
    Dungeon.current.each_with_index do |row, y|
      $screen_shot[y] ||= []
      row.each_with_index do |col, x|
        if Player.seen[Player.depth].include?({x: x, y: y})
          pixel = Dungeon.current[y][x]
          $screen_shot[y][x] = (pixel == "  " ? ". " : pixel).color(:light_black)
        else
          $screen_shot[y][x] = "  "
        end
      end
    end
    visible = Visible.new(Dungeon.current, {x: Player.x, y: Player.y}, Player.vision_radius).find_visible
    visible.each do |in_sight|
        # This makes the current visibility white.
      if Dungeon.current[in_sight[:y]][in_sight[:x]] == "  "
        $screen_shot[in_sight[:y]][in_sight[:x]] = ". "
        $screen_shot_visible << {x: in_sight[:x], y: in_sight[:y]}
      else
        floor = Dungeon.current[in_sight[:y]][in_sight[:x]]
        $screen_shot[in_sight[:y]][in_sight[:x]] = floor
        $screen_shot_visible << {x: in_sight[:x], y: in_sight[:y]}
      end
      Gold.all.each do |gold|
        if gold.x == in_sight[:x] && gold.y == in_sight[:y]
          $screen_shot_objects << {instance: gold, x: gold.x, y: gold.y}
        end
      end
      Item.on_board.each do |item|
        if item.coords
          if item.x == in_sight[:x] && item.y == in_sight[:y]
            $screen_shot_objects << {instance: item, x: item.x, y: item.y}
          end
        end
      end
      Creature.all.each do |creature|
        if creature.x == in_sight[:x] && creature.y == in_sight[:y]
          $screen_shot_objects << {instance: creature, x: creature.x, y: creature.y}
        end
      end if Creature.all
    end
    $screen_shot_objects << {instance: Player, x: Player.x, y: Player.y}
    $screen_shot
  end

  def self.describe(pixel, coords)
    response = case pixel.clone.uncolor.split.join
    when '▒' then 'an unbreakable wall'
    when '#' then 'a rock'
    when '>' then 'a staircase downwards'
    when '<' then 'a staircase upwards'
    when '.' then 'some dirt'
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    when '' then ''
    else ""
    end
    stack = []
    # Do not change their color
    $screen_shot_objects.each do |obj|
      stack << obj if {x: obj[:x], y: obj[:y]} == coords
    end
    if response.length > 0 || stack.length > 0
      if stack.count == 0
        "This is #{response}."
      else
        str = case stack.count
        when 1
          case stack.first[:instance].class.to_s
          when "Class" then "I am standing on #{response}."
          when "Gold" then "There is some gold #{('on ' + response + ' ') if response != 'some dirt'}here."
          when "" then Game.input true; binding.pry
          else
            if stack.first[:instance].name
              "There is #{stack.first[:instance].name.articlize} #{('on ' + response + ' ') if response != 'some dirt'}here."
            else
              "Something is weird."
              Game.input true; binding.pry
            end
          end
        when 2
          if stack.map {|s|s[:instance].class.to_s}.uniq.length == 1
            "There is a stack of #{stack.first[:instance].name} here."
          else
            "There is #{stack.last[:instance].name.articlize} on #{stack.first[:instance].name.articlize} here."
          end
        else "There are #{stack.count} things here. "
          if stack.map {|s|s[:instance].class.to_s}.uniq.length == 1
            "There is a stack of #{stack.first[:instance].name} here."
          else
            "There is a stack of #{stack.first[:instance].name.articlize} and other things."
          end
        end
        "#{str}\n#{VIEWPORT_WIDTH.times.map{'  '}.join}#{stack.map {|i|"\n" + i[:instance].name.capitalize}.join}"
      end
    else
      "I don't know what this is."
    end
  end
end
