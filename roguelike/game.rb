class Game

  def self.start
    STDIN.echo = false
    $time = 0
    $player = Player.new
    dungeon = Dungeon.new.build(200)
    $player.x = dungeon.left.abs + 1
    $player.y = dungeon.top.abs + 1
    $dungeon = []
    $dungeon[$player.depth] = dungeon.to_array
    width = $dungeon[$player.depth].length
    height = $dungeon[$player.depth].first.length
    height.times do |y|
      $dungeon[$player.depth][0][y] = "▒ "
      $dungeon[$player.depth][width - 1][y] = "▒ "
    end
    $dungeon[$player.depth].each_with_index do |x, pos|
      $dungeon[$player.depth][pos][0] = "▒ "
      $dungeon[$player.depth][pos][height] = "▒ "
    end
    $level = update_level
  end

  def self.draw(board=$level)
    puts board.collect {|row| row.join}.join("\n")
    puts $time
  end

  # Dungeon should never be colored!
  # Player vision no longer shows?
  #  53x20?

  def self.update_level
    $level = Array.new ($dungeon[$player.depth].length) {Array.new($dungeon[$player.depth].first.count) {"  "}}
    # Do not do circle code unless dungeon == dark
    # Check distance between all enemies. If in radius, then draw them
    $player.seen.uniq!
    $player.seen.each do |seen|
      # This makes what the player has previously seen into gray.
      pixel = $dungeon[$player.depth][seen[:y]][seen[:x]]
      $level[seen[:y]][seen[:x]] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
    end
    visible = Visible.new($dungeon[$player.depth], {x: $player.x, y: $player.y}, 5).find_visible
    visible.each do |in_sight|
      $player.seen << in_sight
      if $dungeon[$player.depth][in_sight[:y]][in_sight[:x]] == "  "
        $level[in_sight[:y]][in_sight[:x]] = "\e[33m. \e[0m"
      else
        # This makes the current visibility yellow.
        white = $dungeon[$player.depth][in_sight[:y]][in_sight[:x]]
        color = "\e[93m#{white}\e[0m"
        $level[in_sight[:y]][in_sight[:x]] = color
      end
    end
    $level[$player.y][$player.x] = $player.show
    $level
  end
end
