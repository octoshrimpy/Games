# TODO
=begin
Expand 'stack' to more info in Explore- list all items in the stack
Show inventory
press 's' to bring up 'select'
hit 's' again to choose
hit 'esc' to deactivate select
'Select' cursor in relevant menus
'select' inventory
'select' to change hotkeys
refactor heal/hurt sources to objects instaed of strings
change Player.hurt -> Player.hit, calculate damage based on opponents strength and self.defense



=end
require 'pry-remote' # TODO Remove this!

require 'io/console'
require './monkey_patches.rb'
require './key_bindings.rb'
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
require './settings.rb'
require './dungeon.rb'
require './visible.rb'

Game.start
system 'clear' or system 'cls'
Game.draw

while(true)
  input = Input.read_single_key
  if input
    $milli_tick = Time.now.to_f
    Settings.receive(input)
    if Player.try_action(input)
      Game.run_time(Player.speed)

      Game.draw
      sleep 0.03
    end
    sleep 0.07
  end
end
