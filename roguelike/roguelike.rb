require 'pry-remote' # TODO Remove this!

require 'io/console'
require './monkey_patches.rb'
require './input.rb'
require './log.rb'

require './gold.rb'
require './items.rb'
require './equipment.rb'
require './melee_weapon.rb'
require './ranged_weapon.rb'
require './magic_weapon.rb'

require './creature.rb'
require './player.rb'

require './game.rb'
require './dungeon.rb'
require './visible.rb'

Game.start
system 'clear' or system 'cls'
Game.draw

while(true)
  input = Input.read_single_key
  if Player.try_action(input)
    $milli_tick = Time.now.to_f
    Game.run_time(Player.speed) #Change this to reflect whether the action is movement or attack

    system 'clear' or system 'cls'
    Game.draw
    sleep 0.1
  end
  Game.draw(Dungeon.current) if input == "D"
end
