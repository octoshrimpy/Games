class Game

  def self.start
    $world = []
    $tick = 0
    $time = 0
    $player = Player.new
    $dungeon = []
    # $player.x = 5
    # $player.y = 5
    # dungeon = Array.new(100) {Array.new(50) {"  "}}
    # $dungeon[$player.depth] = dungeon
    make_dungeon
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
    Game.input(true)
    i = 0
    board.first.length.times {print " _"}
    puts
    while i < board.length
      print "|"
      print board[i].join
      print "|"
      puts ""
      i += 1
    end
    board.first.length.times {print " _"}
    puts
    puts "Time: #{$tick}"
    puts "FPS: #{1 / (Time.now.to_f - $time)}"
    puts "Depth: #{$player.depth}"
    Game.input(false)
  end

  def self.use_stairs(direction)
    case direction
    when "UP"
      if $dungeon[$player.depth - 1]
        $player.depth -= 1
        $player.x += ($world[$player.depth + 1][:offset][:x] - $world[$player.depth][:offset][:x])
        $player.y += ($world[$player.depth + 1][:offset][:y] - $world[$player.depth][:offset][:y])

        $height = $dungeon[$player.depth].length
        $width = $dungeon[$player.depth].first.length
      end
    when "DOWN"
      $player.depth += 1
      if $dungeon[$player.depth]
        $player.x += ($world[$player.depth - 1][:offset][:x] - $world[$player.depth][:offset][:x])
        $player.y += ($world[$player.depth - 1][:offset][:y] - $world[$player.depth][:offset][:y])

        $height = $dungeon[$player.depth].length
        $width = $dungeon[$player.depth].first.length
      else
        Game.make_dungeon($world[$player.depth - 1][:offset], {x: $player.x, y: $player.y})
      end
    end
  end

  def self.make_dungeon(offset={x: 0, y: 0}, player_coords={x: 0, y: 0})
    dungeon = Dungeon.new.build(200)
    $dungeon[$player.depth] = dungeon.to_array

    $player.x = dungeon.left.abs + 1
    $player.y = dungeon.top.abs + 1

    $world[$player.depth] ||= {}
    $world[$player.depth][:up] ||= []
    $world[$player.depth][:down] ||= []
    layer_offset = {
      x: (offset[:x] + player_coords[:x] - $player.x),
      y: (offset[:y] + player_coords[:y] - $player.y)
    }
    $world[$player.depth][:offset] = layer_offset

    $height = $dungeon[$player.depth].length
    $width = $dungeon[$player.depth].first.length

    $width.times do |y|
      $dungeon[$player.depth][0][y] = "▒ "
      $dungeon[$player.depth][$height - 1][y] = "▒ "
    end

    $height.times do |x|
      $width.times do |y|
        pixel = $dungeon[$player.depth][x][y].uncolor
        direction = case pixel
        when "<" then :up
        when ">" then :down
        end
        if direction
          $world[$player.depth][direction] << {
            x: x,
            y: y
          }
        end
      end
      $dungeon[$player.depth][x][0] = "▒ "
      $dungeon[$player.depth][x][$width] = "▒ "
    end

    $level = update_level
  end

  # Dungeon should never be colored!
  # Player vision no longer shows?
  #  53x20?

  def self.update_level
    viewport_width = 41
    viewport_height = 21
    $player.seen[$player.depth] ||= []
    # $level = Array.new ($dungeon[$player.depth].length) {Array.new($dungeon[$player.depth].first.count) {"  "}}
    $level = Array.new (viewport_height) {Array.new(viewport_width) {"  "}}
    x_offset = $player.x - (viewport_width / 2)
    y_offset = $player.y - (viewport_height / 2)
    x_offset = x_offset < 0 ? 0 : x_offset
    y_offset = y_offset < 0 ? 0 : y_offset
    x_offset = x_offset > ($width - viewport_width + 1) ? ($width - viewport_width + 1) : x_offset
    y_offset = y_offset > ($height - viewport_height) ? ($height - viewport_height) : y_offset

    # Do not do circle code unless dungeon == dark
    # Check distance between all enemies. If in radius, then draw them
    # Only do 1 calculation.

    viewport = []
    $player.seen[$player.depth].each do |see|
      in_x = (see[:x] >= x_offset) && (see[:x] < x_offset + viewport_width)
      in_y = (see[:y] >= y_offset) && (see[:y] < y_offset + viewport_height)
      viewport << {x: see[:x], y: see[:y]} if in_x && in_y
    end
    # binding.pry
    # $player.seen[$player.depth].each do |seen|
    viewport.each do |seen|
      # This makes what the player has previously seen gray.
      pixel = $dungeon[$player.depth][seen[:y]][seen[:x]]
      $level[seen[:y] - y_offset][seen[:x] - x_offset] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
    end
    visible = Visible.new($dungeon[$player.depth], {x: $player.x, y: $player.y}, 5).find_visible
    visible.each do |in_sight|
      $player.seen[$player.depth] << in_sight
        # This makes the current visibility yellow.
      if $dungeon[$player.depth][in_sight[:y]][in_sight[:x]] == "  "
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = ". "
      else
        floor = $dungeon[$player.depth][in_sight[:y]][in_sight[:x]]
        $level[in_sight[:y] - y_offset][in_sight[:x] - x_offset] = floor
      end
    end
    # Draw enemies
    $level[$player.y - y_offset][$player.x - x_offset] = $player.show
    $level
  end
end
