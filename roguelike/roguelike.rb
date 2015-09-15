# TODO
=begin

add descriptions for items

More advanced books have more spells
Able to transcribe scrolls into books if the element matches

Vision calculation is a little off. Radius 2, Player does not see (+2, +1), but sees (-2, +1)

http://fantasynamegenerators.com/magic-book-names.php#.Ve3efGA_78H

Greatly reduce magic damage, scale magic damage with magic power
Allow purchase of items to increase defense and power

Allow 'read more' to work in the Equipment screen

Reduce FOV greatly. Allow light sources to be placed. Light sources should store coordinates so that they do not continually have to calculate it, since they are static

Collision detection of projectiles seems off

If 2 weapons have the same stat bonus, show +0 instead of blank.

Quiver should only increase stack size for 1 stack. Any overflow should stack normally

If 's' while standing on items and overflow inventory, should open inventory and be able to swap the selected item from the floor stack with an item in the inventory

Fix scaling for enemies. Scale VERY slowly, and over time switch out monsters.
  Monsters should have base damage + small level multiplier

Ranged enemies

dodged/blocked only when necessary. Some items (magic spells) won't do damage on collision, but should show a status effect.
"{} has been poisoned/burned/etc"

Character Experience/levels
Scaling for enemies
Enemy special abilities?

Every 10 levels, spawn a BOSS. -> Downstairs should be hidden until Boss has been defeated.
Build the town to buy/sell stuff.

Enemy spawning rarity. Some monsters are more common than others, depending on the floor

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
require './evals.rb'
require './key_bindings.rb'
require './input.rb'
require './log.rb'

require './gold.rb'
require './gems.rb'
require './item.rb'
require './visual_effect.rb'
require './dot_effect.rb'
require './consumable.rb'
require './projectile.rb'
require './equipment.rb'
require './melee_weapon.rb'
require './static_item.rb'
require './ranged_weapon.rb'
require './magic_weapon.rb'
require './spell_book.rb'
require './spell.rb'

require './creature.rb'
require './player.rb'

require './game.rb'
require './settings.rb'
require './dungeon.rb'
require './visible.rb'

seed = 40.times.map {|a| (rand_seed ||= Random.new_seed.to_s)[a] ? rand_seed[a] : 1}.join.to_i
Game.start(seed)

Player.inventory << Item['Standard Bow']
15.times { Player.inventory << Item['Arrow'] }
Player.inventory << Item['Fire Sword']
Player.inventory << Item['Rusty Dagger']
Player.inventory << Item['Book of Fire']
Player.quickbar = ["Standard Bow", "Bread Scrap", "Book of Fire", "Fire Blast", nil, nil, nil, nil, nil]
5.times { Player.inventory << Item['Scroll of Flash'] }
Creature.new('m', :light_green).spawn
# Player.invincibility = 999999999

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
