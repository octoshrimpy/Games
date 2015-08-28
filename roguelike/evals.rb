class Evals
  def self.player_invisible(num); "Player.visibility(#{num})"; end
  def self.unstable_teleportation; "sleep(0.3); Player.coords = Dungeon.find_open_spaces(false).sample; Game.tick; true"; end
  def self.flash(distance=5); "$gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_select_position}' to choose coordinate.\"; false"; end
  def self.resurrect_player; "Player.resurrect"; end
  def self.explode(radius, damage); "aoe(#{radius}, 'Item.damage_to_coord(coord, #{damage}, \"fire\")'); destroy"; end
  def self.poison(duration, damage); "DotEffect.new(collided_with, #{duration}, Evals.poison_tick(#{damage})); destroy"; end
  def self.poison_tick(damage); "dot.effector.hurt(#{damage}, 'poison') if dot.effector.is_a?(Creature)"; end
  def self.burn(duration, damage); "DotEffect.new(effected, #{duration}, Evals.burn_tick(#{damage}))"; end
  def self.burn_tick(damage); "dot.effector.hurt(#{damage}, 'fire') if dot.effector.is_a?(Creature)"; end
end
