class Game

  SPAWN_RATE = 100
  MAX_ENEMIES = 10
  STATS_GUI_WIDTH = 10
  LOGS_GUI_HEIGHT = 5
  VIEWPORT_WIDTH = 41
  VIEWPORT_HEIGHT = 21

  class << self

    def start(seed)
      $seed = seed
      srand($seed.to_i)
      $message = "Welcome! Press '#{$key_mapping[:open_help]}' at any time to view how to play."
      $previous_message = ''

      $items = []
      $drops = []
      $projectiles = []
      $visual_effects = []
      $dot_effects = []

      $gamemode = "play"
      $gameover = false

      $screen_shot = nil
      $screen_shot_objects = []
      $screen_shot_visible = []
      $world = []
      $dungeon = []
      $stack = []

      $all_inputs = []
      $time = 0
      $milli_tick = 0
      $visible_calculations = 0

      $ids = 1
      $spawn_creatures = true
      $npcs = []

      $fps = []
      $tick = 1
      $skip = 0
      $auto_pilot_condition = ''

      Item.generate
      Log.new
      Log.add "Welcome to the game!"
      make_dungeon
    end

    def tick(draw=true)
      if $gameover
        $gamemode = 'dead' if $gamemode == 'play'
      else
        Player.tick
        Game.run_time(Player.speed)
        Item.tick

        Game.update_level
        Game.draw if draw
        VisualEffect.tick if VisualEffect.all
        DotEffect.tick if DotEffect.all
        sleep 0.03 if draw && $fps.last > 50
      end
    end

    def movement_keys
      cardinal = [$key_mapping[:move_up], $key_mapping[:move_left], $key_mapping[:move_right], $key_mapping[:move_down]]
      diagonal = [$key_mapping[:move_up_left], $key_mapping[:move_up_right], $key_mapping[:move_down_left], $key_mapping[:move_down_right]]
      standard_directions = [cardinal.map(&:capitalize), diagonal.map(&:capitalize), cardinal, diagonal].flatten
      arrow_keys = %w( Shift-Up Shift-Left Shift-Right Shift-Down UP LEFT RIGHT DOWN )
      standard_directions + arrow_keys
    end

    def run_time(time)
      (100 / time).times do |t|
        Creature.on_board.each do |creature|
          creature.tick if (creature.birth + $tick) % (100 / creature.run_speed) == 0
        end if Creature.on_board
        spawn_creature if ($time % SPAWN_RATE == 0 && Creature.count < MAX_ENEMIES && $spawn_creatures == true)
        Projectile.all.each { |shot| shot.tick if ($tick - shot.dob) % (100 / shot.speed) == 0 }
        $tick += 1
      end
      LightSource.tick
      Player.verify_stats
      $time += 1
    end

    def redraw
      $level = Game.update_level
      Game.draw
    end

    def pause
      Game.input(true)
      binding.pry
    end

    def end
      Game.input(true)
      exit 0
    end

    def overlay_string(str, color, times, gui_width)
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

    def input(bool=true)
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

    def show(coords=Player.coords)
      board = Array.new (VIEWPORT_HEIGHT) {Array.new(VIEWPORT_WIDTH) {"  "}}

      x_offset = coords[:x] - (VIEWPORT_WIDTH / 2)
      y_offset = coords[:y] - (VIEWPORT_HEIGHT / 2)
      x_offset = x_offset < 0 ? 0 : x_offset
      y_offset = y_offset < 0 ? 0 : y_offset
      x_offset = x_offset > ($width - VIEWPORT_WIDTH + 1) ? ($width - VIEWPORT_WIDTH + 1) : x_offset
      y_offset = y_offset > ($height - VIEWPORT_HEIGHT) ? ($height - VIEWPORT_HEIGHT) : y_offset

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
              pixel_color = if coords[:range].to_i > 0
                in_range_x = (coords[:x] - Player.x).abs <= coords[:range]
                in_range_y = (coords[:y] - Player.y).abs <= coords[:range]
                in_range_x && in_range_y ? :blue : :red
              else
                :blue
              end
              pixel = "#{pixel.uncolor[0]}#{'<'}".color(:white, pixel_color)
            end
            board[y - y_offset][x - x_offset] = pixel
          end
        end
      end

      $screen_shot_objects.each do |obj|
        obj_coords = obj.coords.filter(:x, :y)
        x, y = obj_coords.values
        in_x = (x >= x_offset) && (x < x_offset + VIEWPORT_WIDTH)
        in_y = (y >= y_offset) && (y < y_offset + VIEWPORT_HEIGHT)
        if in_x && in_y
          pixel = if obj_coords == coords.filter(:x, :y)
            "#{obj.show.uncolor[0]}#{'<'}".color(:white, :blue)
          else
            obj.show
          end
          board[y - y_offset][x - x_offset] = pixel
        end
      end

      Game.draw(board)
      puts "Looking at: (#{coords[:x]}, #{coords[:y]})"
    end

    def ground_objects
     (Gold.on_board + Item.on_board + Creature.on_board + Gems.on_board + Projectile.all + VisualEffect.all)
    end

    def ground_objects_at(coords)
     (Gold.on_board + Item.on_board + Creature.on_board + Gems.on_board + Projectile.all + VisualEffect.all).select { |obj| obj.coords == coords }
    end

    def draw(board=$level)
      Player.verify_stats
      system 'clear' or system 'cls'
      if Creature.on_board && Creature.count == 0 && $spawn_creatures == true
        $spawn_creatures = false
        Log.add "You have eradicated all forms of life on this floor."
      end
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
        print "...(#{$key_mapping[:read_more]})" if $message.length > (VIEWPORT_WIDTH*2 - 7)
        $previous_message = $message.clone
        $message = ""
      end
      puts
      (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "--"}
      puts "+\rStats "
      # Should calculate the board first, then draw it all at once.
      VIEWPORT_HEIGHT.times do |i|
        print "0" #Placeholder
        STATS_GUI_WIDTH.times do
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

    def debugger_tools
      fps = 1 / (Time.now.to_f - $milli_tick)
      $fps << fps
      $fps.shift while $fps.length > 50
      avg_fps = $fps.inject(:+).to_f / $fps.size
      puts "Time: #{$time}"
      puts "Game Mode: #{$gamemode}"
      puts "Player: #{Player.visible ? 'visible' : 'invisible for ' + (Player.invisibility_ticks - 1).to_s}"
      puts "Player speed: #{Player.speed}"
      puts "Ticks: #{$tick}"
      puts "FPS: #{fps}"
      puts "Average FPS: #{avg_fps}"
      puts "Depth: #{Player.depth}"
      puts "Creatures left: #{Creature.count if Creature.on_board}"
      puts "My location: (#{Player.x}, #{Player.y})"
      puts "Vision Calculations: #{$visible_calculations}"
      $visible_calculations = 0
      print "Creature locations: "
      Creature.on_board.each do |creature|
        foreground = creature.player_in_range? ? :red : nil
        background = creature.name == 'Slime' ? :green : nil
        print " (#{creature.x}, #{creature.y}) ".color(foreground, background)
      end if Creature.on_board
      puts
    end

    def draw_stats(row)
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
        print " "
        Player.quickbar.map { |name|
          item = Item.by_name(name)
          item_ammo = Item.by_name(item.ammo_types) if item.respond_to?(:ammo_types)
          ammo = item_ammo ? "#{item_ammo.show}\b" : ' '
          item ? "#{item.show}\b#{ammo.override_background_with(:light_black)}\e[100;30m" : "  "
        }.join("")
      end
      puts "\e[100;37m"
    end

    def draw_logs(board)
      (VIEWPORT_WIDTH + STATS_GUI_WIDTH + 1).times {print "--"}
      print "+\rLogs "
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
      print "+-"
      (VIEWPORT_WIDTH + STATS_GUI_WIDTH).times {print "--"}
      puts "+\e[0m"
    end

    def use_stairs(direction)
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

    def make_dungeon(offset={x: 0, y: 0}, player_coords={x: 0, y: 0})
      preset = case
      when Player.depth == 0 then 'outside'
      when Player.depth % 10 == 0 then 'boss'
      when Player.depth % 7 == 0 then 'cavernous'
      when Player.depth % 5 == 0 then 'maze'
      when Player.depth % 3 == 0 then 'tunnels'
      else 'default'
      end
      until (dungeon_up ||= false) && (dungeon_down ||= false)
        dungeon = Dungeon.new(preset).build!(preset)
        dungeon_up = dungeon.search_for("< ").first
        dungeon_down = dungeon.search_for("> ").first
      end

      $dungeon[Player.depth] = dungeon

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

      Player.coords = dungeon_up

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

    def run_dungeon_tests(num)
      time = Time.now.to_f
      count = 0
      print "\e[32m"
      num.times do |t|
        dungeon = Dungeon.new.standard_build(300).flatten
        print dungeon.include?("< ") ? "." : (count+=1;"\e[31mF\e[32m")
        print dungeon.include?("> ") ? "." : (count+=1;"\e[31mF \e[32m")
      end
      puts "\e[0m"
      puts "Created #{num} dungeons. Took #{(Time.now.to_f - time).round(1)} seconds. There was #{count} failures."
    end

    def populate_dungeon
      MAX_ENEMIES.times do |t|
        spawn_creature
      end
      Dungeon.current.each_with_index do |y, ypos|
        y.each_with_index do |x, xpos|
          unless Dungeon.current[ypos][xpos].is_unbreakable? || rand(100) > 0
            depth = Player.depth
            low_val = (depth / 5).ceil + 1
            high_val = (depth / 4).ceil + 1
            gold_value = rand(low_val..high_val)
            Gold.new({x: xpos, y: ypos, depth: depth, value: gold_value.ceil})
            Game.input true; binding.pry if ypos == 0
            Dungeon.current[ypos][xpos] = "  "
          end
        end
      end
      current_depth = Player.depth

      case current_depth
      when 1
        coord = Dungeon.find_open_spaces.sample.merge({depth: current_depth})
        sword = Item["Rusty Dagger"]
        sword.drop(coord)
      end
      if current_depth % 10 == 0
        coord = Dungeon.find_open_spaces.sample
        Gems.new(
          pickup_script: 'Log.add("Pickup up Gem. Max Health and Max Mana increased."); Player.raw_max_health += 5; Player.raw_max_mana += 2; Player.revitalize!',
          x: coord[:x],
          y: coord[:y],
          depth: current_depth
        )
      end

    end

    def spawn_creature
      color = :red
      possibilities = []
      type = Creature.creatures_on_level(Player.depth).sample
      Creature.new(type, color).spawn
    end

    def update_level
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

    def find_currently_visible(x_offset, y_offset)
      currently_lit = Visible.new(Dungeon.current, {x: Player.x, y: Player.y}, Player.lit_radius).find_visible
      currently_lit += LightSource.find_visible
      currently_lit.compact.flatten.each do |in_sight|
        Player.seen[Player.depth] << in_sight unless Player.seen[Player.depth].include?(in_sight)
        next unless $level && $level[in_sight[:y] - y_offset] && $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset]
        # This makes the current visibility white.
        floor = Dungeon.current[in_sight[:y]][in_sight[:x]]
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = floor == "  " ? ". " : floor
        ground_objects.each do |item_on_board|
          if item_on_board.coords.filter(:x, :y) == in_sight.filter(:x, :y) && Visible.in_range(Player.vision_radius, in_sight, Player.coords)
            $level[item_on_board.y - y_offset][item_on_board.x - x_offset] = item_on_board.show
          end
        end
      end
      $level[Player.y - y_offset][Player.x - x_offset] = Player.show
    end

    def get_screen_shot
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
      currently_lit = Visible.new(Dungeon.current, {x: Player.x, y: Player.y}, Player.lit_radius).find_visible
      currently_lit += LightSource.find_visible
      currently_lit.compact.each do |in_sight|
        $screen_shot_visible << in_sight.filter(:x, :y)
        # This makes the current visibility white.
        floor = Dungeon.current[in_sight[:y]][in_sight[:x]]
        $screen_shot[in_sight[:y]][in_sight[:x]] = floor == "  " ? ". " : floor
        ground_objects.each do |item_on_board|
          if item_on_board.coords.filter(:x, :y) == in_sight.filter(:x, :y) && Visible.in_range(Player.vision_radius, in_sight, Player.coords)
            $screen_shot_objects << item_on_board
          end
        end
      end
      $screen_shot_objects << Player
      $screen_shot
    end

    def describe(pixel, coords)
      player_here = coords == Player.coords
      is_map = $gamemode == 'map'
      response = player_here ? "I'm standing on " : 'There is '

      standing_pixel = case pixel.clone.uncolor.split.join
      when '▒' then 'an unbreakable wall'
      when '#' then 'a rock'
      when '>' then 'a staircase downwards'
      when '<' then 'a staircase upwards'
      when '.' then 'some dirt'
      when '' then ''
      else ""
      end
      $stack = []
      # Do not change their color
      Game.input(true); binding.pry if $all_inputs.last == 'o'
      drops = $drops.flatten.compact.select { |drop| drop.coords == coords }
      (Item.at(coords) + drops).each do |obj|
        $stack << obj if obj.coords.filter(:x, :y) == coords.filter(:x, :y) && obj != Player
      end
      stacks = $stack.group_by { |item| item.name }
      stack_size = $stack.size

      if standing_pixel =~ /staircase/
        response << standing_pixel
        response << (stack_size > 0 ? ' and some other things' : '')
      else
        response << case stacks.size
        when 0 then standing_pixel
        when 1 then (stack_size == 1 || $stack.first.stack_size == 1) ? "#{$stack.first.name.articlize}" : "a stack of #{$stack.first.name.articlize}"
        when 2
          top_stack, bottom_stack = stacks.to_a.first[1], stacks.to_a.last[1]
          top_item, bottom_item = top_stack.first, bottom_stack.first
          line = ''
          line << (top_item.stack_size == 1 || top_stack.size == 1 ? "#{top_item.name.articlize}" : "a stack of #{top_item.name.articlize}")
          line << " on "
          line << (bottom_item.stack_size == 1 || bottom_stack.size == 1 ? "#{bottom_item.name.articlize}" : "a stack of #{bottom_item.name.articlize}")
          line
        else player_here ? "#{stack_size} things" : "\b\b\bare #{stack_size} things"
        end
      end

      response << (is_map ? " here.\n" : ".\n")
      response = "I don't know what this is." if standing_pixel.length == 0 && stack_size == 0
      response << (VIEWPORT_WIDTH.times.map{'  '}.join + "\n")
      response << stacks.map { |item_name, item_list| "#{item_name}#{item_list.count > 1 ? " x#{item_list.count}" : ''}\n"}.join
    end
  end
end
