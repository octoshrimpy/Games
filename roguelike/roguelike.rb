require 'io/console'
require 'pry'
require './visible.rb'
require './arena.rb'
require './dungeon.rb'
require './player.rb'
require './game.rb'
require './input.rb'
require './monkey_patches.rb'

Game.start
system 'clear' or system 'cls'
Game.draw

while(true)
  input = Input.read_single_key
  if $player.try_action(input)
    $level = Game.update_level
    system 'clear' or system 'cls'
    Game.draw
    $time += 1
    sleep 0.05
  end
  draw($dungeon[$player.depth]) if input == "D"
end
