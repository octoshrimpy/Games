# TODO
=begin
Make more efficient- If Player is in hallway, do we check for every single block outside of the hallway?
^^ nope! I hope?

magic and spells!!

Character Experience/levels
Scaling for enemies
Enemy special abilities?

Equip and use Hot keys
'select' to change hotkeys

Add a menu to show the character stats (including bonuses from armor/weapons/potions)

Save data

Configure defense of player and creatures to reduce damage taken.
change Player.hurt -> Player.hit, calculate damage based on opponents strength and self.defense

refactor heal/hurt sources to objects instead of strings

Allow Player to level up and increase stats
Have skill levels for different types of weapons
Incorporate two handed weapons
(2-handed weapons grant speed reduction if there is an item in the other hand)

Create a fallback for all items. What do they do when used/consumed?

Allow player to select items from the drop menu in order to pick them up manually

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\

Saving data -

Assign a seed value
Use that value for everything in the game

At startup, request user to select a load file or to create a new one.

This should save all variables.
Save something like this:
"$dungeon=#{$dungeon}"


=end
# How many lines?
# Dir["./*"].inject(0) {|count, path| count + %x{wc -l < "#{path}"}.to_i}

require 'pry-remote' # TODO Remove this!

require 'io/console'
require './monkey_patches.rb'
require './key_bindings.rb'
require './input.rb'
require './log.rb'

require './gold.rb'
require './item.rb'
require './consumable.rb'
require './projectile.rb'
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
  weight: 0.1,
  name: "Bread of Invisibility",
  usage_verb: 'consumed',
  restore_energy: 10,
  stack_size: 10,
  icon: '`',
  x: 10,
  y: 10,
  depth: 1,
  execution_script: "Player.visibility(10)"
})
bread.x = Player.x + 1
bread.y = Player.y + 1
10.times { bread.duplicate }
Dungeon.current[Player.y + 1][Player.x + 1] = "  "
Player.inventory << Consumable.new({
  weight: 1,
  name: "Scroll of Unstable Teleportation",
  stack_size: 10,
  icon: '%',
  execution_script: "Player.coords = Dungeon.find_open_spaces.sample"
})
system 'clear' or system 'cls'
Game.draw

while(true)
  if $gamemode != 'sleep'
    input = Input.read_single_key
    if input
      $milli_tick = Time.now.to_f
      Settings.receive(input)
      if $skip == 0 && Player.try_action(input)
        Game.tick
      else
        $skip -= 1
        $skip = $skip < 0 ? 0 : $skip
      end
      # sleep 0.07
    end
  else
    if eval($sleep_condition)
      Log.add "You have awoken."
      $gamemode = 'play'
      Game.redraw
    else
      Player.tick
      Game.run_time(Player.speed)
    end
  end
end
