# TODO
=begin
Make more efficient- If Player is in hallway, do we check for every single block outside of the hallway?
^^ nope!
Create consumable items (food to restore energy)

'select' inventory
projectile weapons
'select' to change hotkeys
refactor heal/hurt sources to objects instaed of strings
change Player.hurt -> Player.hit, calculate damage based on opponents strength and self.defense

Have skills for different types of weapons
Incorporate two handed weapons

after selecting throw, should redraw screen with message.
Message = "Select direction to throw or * to choose coord"
do that.

Allow player to select items from the drop menu in order to pick them up manually

settings #238/239 drop and throw items
Create a fallback for all items. What do they do when used/consumed?


=end
require 'pry-remote' # TODO Remove this!

require 'io/console'
require './monkey_patches.rb'
require './key_bindings.rb'
require './input.rb'
require './log.rb'

require './gold.rb'
require './items.rb'
require './consumable.rb'
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

bread = Consumable.new({
  weight: 1,
  name: "Bread of Invisibility",
  icon: '`',
  x: 10,
  y: 10,
  depth: 1,
  special_effect: "Player.visibility(10)"
})
bread.x = Player.x + 1
bread.y = Player.y + 1
Dungeon.current[Player.y + 1][Player.x + 1] = "  "
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
    # sleep 0.07
  end
end
