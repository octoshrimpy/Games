class Game

  def self.start
    $world = []
    $tick = 0
    $time = 0
    $player = Player.new
    $npcs = []
    $dungeon = []
    $log = []
    $fps = []
    # Player.me.x = 5
    # Player.me.y = 5
    # dungeon = Array.new(100) {Array.new(50) {"  "}}
    # $dungeon[Player.me.depth] = dungeon
    make_dungeon
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
    binding.pry if new_str.length < gui_width
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
    stats_gui_width = 10
    logs_gui_height = 10
    Game.input(true)
    print "\e[100m"
    (board.first.length + stats_gui_width + 1).times {print "--"}
    print " \rStats "
    puts
    # Should calculate the board first, then draw it all at once.
    i = 0
    while i < board.length
      print "|"
      stats_gui_width.times do |t|
        print "  "
      end
      print "|\e[0m"
      print board[i].join
      print "\e[100m"
      print "|"
      print "\r| "
      print case i
      when 0
        hp = (Player.me.health / Player.me.max_health.to_f) * 100.00
        max = ((hp / stats_gui_width.to_f) * 2.00).round
        color = case hp
        when 60..100 then 42
        when 30..60 then 43
        when 0..30 then 41
        else 7
        end
        print "\e[30m"
        overlay_string(" Health: #{Player.me.health}/#{Player.me.max_health}", color, max, stats_gui_width*2)
      when 1
        hp = (Player.me.mana / Player.me.max_mana.to_f) * 100.00
        max = ((hp / stats_gui_width.to_f) * 2.00).round
        color = case hp
        when 60..100 then 46
        when 20..60 then 104
        when 0..20 then 45
        else 7
        end
        print "\e[30m"
        overlay_string(" Mana: #{Player.me.mana}/#{Player.me.max_mana}", color, max, stats_gui_width*2)
      end
      print "\e[100;37m"
      puts ""
      i += 1
    end
    print "\e[100m"
    (board.first.length + stats_gui_width + 1).times {print "--"}
    print " \rLogs "
    puts
    i = 0
    while i < logs_gui_height
      print "|"
      (board.first.length + stats_gui_width).times do |t|
        print "  "
      end
      print " |"
      print "\r| "
      logs = $log.last(20).reverse
      print "\e[30m"
      print logs[i][0..((board.first.length + stats_gui_width - 1)*2)] if logs[i]
      print "\e[100;37m"
      puts ""
      i += 1
    end
    (board.first.length + stats_gui_width + 1).times {print "--"}
    print " \e[0m"
    puts
    fps = 1 / (Time.now.to_f - $time)
    $fps << fps
    $fps.shift while $fps.length > 50
    avg_fps = $fps.inject(:+).to_f / $fps.size
    puts "Time: #{$tick}"
    puts "FPS: #{fps}"
    puts "Average FPS: #{avg_fps}"
    puts "Depth: #{Player.me.depth}"
    puts "Creatures left: #{$npcs[Player.me.depth].count if $npcs[Player.me.depth]}"
    puts "My location: (#{Player.me.x}, #{Player.me.y})"
    creature_locations = $npcs[Player.me.depth].map do |creature|
      "(#{creature.x}, #{creature.y})"
    end if $npcs[Player.me.depth]
    puts "Creature locations: #{creature_locations}"
    Game.input(false)
  end

  def self.use_stairs(direction)
    case direction
    when "UP"
      if $dungeon[Player.me.depth - 1]
        Player.me.depth -= 1
        Player.me.x += ($world[Player.me.depth + 1][:offset][:x] - $world[Player.me.depth][:offset][:x])
        Player.me.y += ($world[Player.me.depth + 1][:offset][:y] - $world[Player.me.depth][:offset][:y])

        $height = $dungeon[Player.me.depth].length
        $width = $dungeon[Player.me.depth].first.length
      end
    when "DOWN"
      Player.me.depth += 1
      if $dungeon[Player.me.depth]
        Player.me.x += ($world[Player.me.depth - 1][:offset][:x] - $world[Player.me.depth][:offset][:x])
        Player.me.y += ($world[Player.me.depth - 1][:offset][:y] - $world[Player.me.depth][:offset][:y])

        $height = $dungeon[Player.me.depth].length
        $width = $dungeon[Player.me.depth].first.length
      else
        Game.make_dungeon($world[Player.me.depth - 1][:offset], {x: Player.me.x, y: Player.me.y})
      end
    end
  end

  def self.make_dungeon(offset={x: 0, y: 0}, player_coords={x: 0, y: 0})
    dungeon = Dungeon.new.build(300)
    $dungeon[Player.me.depth] = dungeon.to_array

    Player.me.x = dungeon.left.abs + 1
    Player.me.y = dungeon.top.abs + 1

    $world[Player.me.depth] ||= {}
    $world[Player.me.depth][:up] ||= []
    $world[Player.me.depth][:down] ||= []
    layer_offset = {
      x: (offset[:x] + player_coords[:x] - Player.me.x),
      y: (offset[:y] + player_coords[:y] - Player.me.y)
    }
    $world[Player.me.depth][:offset] = layer_offset

    $height = $dungeon[Player.me.depth].length
    $width = $dungeon[Player.me.depth].first.length

    $width.times do |y|
      $dungeon[Player.me.depth][0][y] = "▒ "
      $dungeon[Player.me.depth][$height - 1][y] = "▒ "
    end

    $height.times do |x|
      $width.times do |y|
        pixel = $dungeon[Player.me.depth][x][y].uncolor
        direction = case pixel
        when "<" then :up
        when ">" then :down
        end
        if direction
          $world[Player.me.depth][direction] << {
            x: x,
            y: y
          }
        end
      end
      $dungeon[Player.me.depth][x][0] = "▒ "
      $dungeon[Player.me.depth][x][$width] = "▒ "
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

  # Dungeon should never be colored!
  # Player.me vision no longer shows?
  #  53x20?

  def self.update_level
    viewport_width = 41
    viewport_height = 21
    Player.me.seen[Player.me.depth] ||= []
    # $level = Array.new ($dungeon[Player.me.depth].length) {Array.new($dungeon[Player.me.depth].first.count) {"  "}}
    $level = Array.new (viewport_height) {Array.new(viewport_width) {"  "}}
    x_offset = Player.me.x - (viewport_width / 2)
    y_offset = Player.me.y - (viewport_height / 2)
    x_offset = x_offset < 0 ? 0 : x_offset
    y_offset = y_offset < 0 ? 0 : y_offset
    x_offset = x_offset > ($width - viewport_width + 1) ? ($width - viewport_width + 1) : x_offset
    y_offset = y_offset > ($height - viewport_height) ? ($height - viewport_height) : y_offset

    # Do not do circle code unless dungeon == dark
    # Check distance between all enemies. If in radius, then draw them
    # Only do 1 calculation.

    viewport = []
    Player.me.seen[Player.me.depth].each do |see|
      in_x = (see[:x] >= x_offset) && (see[:x] < x_offset + viewport_width)
      in_y = (see[:y] >= y_offset) && (see[:y] < y_offset + viewport_height)
      viewport << {x: see[:x], y: see[:y]} if in_x && in_y
    end
    # binding.pry
    # Player.me.seen[Player.me.depth].each do |seen|
    viewport.each do |seen|
      # This makes what the Player.me has previously seen gray.
      pixel = $dungeon[Player.me.depth][seen[:y]][seen[:x]]
      $level[seen[:y] - y_offset][seen[:x] - x_offset] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
    end
    visible = Visible.new($dungeon[Player.me.depth], {x: Player.me.x, y: Player.me.y}, Player.me.vision_radius).find_visible
    visible.each do |in_sight|
      Player.me.seen[Player.me.depth] << in_sight
        # This makes the current visibility yellow.
      if $dungeon[Player.me.depth][in_sight[:y]][in_sight[:x]] == "  "
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = ". "
      else
        floor = $dungeon[Player.me.depth][in_sight[:y]][in_sight[:x]]
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = floor
      end
      $npcs[Player.me.depth].each do |creature|
        if creature.x == in_sight[:x] && creature.y == in_sight[:y]
          $level[creature.y - y_offset][creature.x - x_offset] = creature.show
        end
      end if $npcs[Player.me.depth]
    end
    $level[Player.me.y - y_offset][Player.me.x - x_offset] = Player.me.show
    $level
  end
end
