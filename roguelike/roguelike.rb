require 'io/console'
require 'pry-remote'
require './visible.rb'
require './dungeon.rb'
require './player.rb'
require './log.rb'
require './creature.rb'
require './game.rb'
require './input.rb'
require './monkey_patches.rb'

Game.start
system 'clear' or system 'cls'
Game.draw

while(true)
  input = Input.read_single_key
  if Player.me.try_action(input)
    $milli_tick = Time.now.to_f
    Game.run_time(Player.me.speed) #Change this to reflect whether the action is movement or attack

    system 'clear' or system 'cls'
    Game.draw
    sleep 0.1
  end
  Game.draw(Dungeon.current) if input == "D"
end
