require 'io/console'
require 'pry'
require './visible.rb'
require './arena.rb'
require './dungeon.rb'
require './player.rb'
require './input.rb'
require './monkey_patches.rb'

def draw
  puts $level.collect {|row| row.join}.join("\n")
end

def update_level
  $level = Array.new ($dungeon.length) {Array.new($dungeon.first.count) {"  "}}
  visible = Visible.new($dungeon, {x: $player.x, y: $player.y}, 5).find_visible
  visible.each do |in_sight|
    $player.seen << in_sight
    $player.seen.uniq!
  end
  $player.seen.each do |seen|
    pixel = $dungeon[seen[:y]][seen[:x]]
    $level[seen[:y]][seen[:x]] = pixel == "  " ? "\e[90m. \e[0m" : "\e[90m#{pixel}\e[0m"
  end
  visible.each do |in_sight|
    if $level[in_sight[:y]][in_sight[:x]] == "  "
      $level[in_sight[:y]][in_sight[:x]] = "\e[33m. \e[0m"
    else
      white = $level[in_sight[:y]][in_sight[:x]]
      if white.is_solid?
        color = "\e[93m#{white}\e[0m"
      else
        color = "\e[93m#{white}\e[0m"
      end
      $level[in_sight[:y]][in_sight[:x]] = color
    end
  end
  $level[$player.y][$player.x] = $player.show
  $level
end

$player = Player.new
dungeon = Dungeon.new.build(200)
$player.x = dungeon.left.abs + 1
$player.y = dungeon.top.abs + 1
$dungeon = dungeon.to_array
$level = update_level

# $dungeon = Array.new(50) {Array.new(50) {"  "}}
# $dungeon.length.times {|t|$dungeon[49][t] = "# ";$dungeon[t][49] = "# ";$dungeon[t][0] = "# ";$dungeon[0][t] = "# "}
# 22.times {|t|$dungeon[t][22] = "< ";$dungeon[22][t] = "< " }

system 'clear' or system 'cls'
draw

while(true)
  input = Input.read_single_key
  $player.try_move(input) if %w(LEFT RIGHT UP DOWN).include?(input)
  binding.pry if input == "P"
  $level = update_level
  system 'clear' or system 'cls'
  draw
end
