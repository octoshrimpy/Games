# TODO
=begin
add descriptions for items

Show explode effect for 1 frame

Should have negative effect for having 0 energy

Spells are broken again. Using mana, not allowing to select direction

Click S to cancel aim/throw/target
Click S to select item in Inventory
^^ Only in inventory

Should not be able to use an item without energy

item modifiers / special abilities
DOT's

Spell books should be read. Using opens another menu where you choose spells
More advanced books have more spells

Make more obvious to the user that hitting 1-9 in menu will jump to that spot

Allow player to sort inventory

Character Experience/levels
Scaling for enemies
Enemy special abilities?

Every 10 levels, spawn a BOSS. Render the map a little differently?
Build the town to buy/sell stuff.
Refactor map generation to allow for different types and specifications

Enemy spawning rarity. Some monsters are more common than others, depending on the floor

Add a menu to show the character stats (including bonuses from armor/weapons/potions)
Allow User to customize Key bindings

Save data

Configure defense of player and creatures to reduce damage taken.
change Player.hurt -> Player.hit, calculate damage based on opponents strength and self.defense

refactor heal/hurt sources to objects instead of strings

Allow Player to level up and increase stats
Have skill levels for different types of weapons
Incorporate two handed weapons
(2-handed weapons grant speed reduction if there is an item in the other hand)

Allow player to select items from the drop menu in order to pick them up manually

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Saving data -

Assign a seed value
Use that value for everything in the game

At startup, request user to select a load file or to create a new one.

This should save all variables.
Save something like this:
"$dungeon=#{$dungeon}"

How many lines?
>> run in irb.
Dir["./*"].inject(0) {|count, path| count + %x{wc -l < "#{path}"}.to_i}

=end

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

seed = 40.times.map {|a| (rand_seed ||= Random.new_seed.to_s)[a] ? rand_seed[a] : 1}.join.to_i
Game.start(seed)

Player.inventory << Item['Scroll of Unstable Teleportation']
Player.inventory << Item['Potion of Resurrection']
Player.inventory << Item['Standard Bow']
Player.inventory << Item['Book of Fire Blast']
100.times { Player.inventory << Item['Arrow'] }
5.times { Player.inventory << Item['Scroll of Flash'] }
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
