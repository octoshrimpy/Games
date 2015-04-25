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
    $time = Time.now.to_f
    $npcs[Player.me.depth].each do |creature|
      creature.wander
    end if $npcs[Player.me.depth]
    $level = Game.update_level
    Player.me.seen[Player.me.depth].uniq!
    system 'clear' or system 'cls'
    Game.draw
    $tick += 1
    sleep 0.1
  end
  Game.draw(Dungeon.current) if input == "D"
end
