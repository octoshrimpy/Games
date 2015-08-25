class Evals
  def self.player_invisible(num); "Player.visibility(#{num})"; end
  def self.unstable_teleportation; "sleep(0.3); Player.coords = Dungeon.find_open_spaces(false).sample; Game.tick; true"; end
  def self.flash(distance=5); "$gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_select_position}' to choose coordinate.\"; false"; end
  def self.resurrect_player; "Player.resurrect"; end
  def self.explode(radius, damage); "aoe(#{radius}, 'Evals.damage_to_coord(coord, #{damage}, \"fire\")'); destroy"; end
  def self.damage_to_coord(coord, damage, type)
    unless Dungeon.at(coord).is_solid?
      VisualEffect.new("Fire Blast Effect", "* ".color(:light_red), coord) # refactor this to be more expandable
      Creature.at(coord).each do |creature|
        creature.hurt(damage, type)
      end
    end
  end
  def self.poison_blast(range, duration, damage); 'DotEffect.new(collided_with, 5, Evals.poison_tick(1)); destroy'; end
  def self.poison_tick(damage); "dot.effector.hurt(#{damage}, 'poison') if dot.effector.is_a?(Creature)"; end
end
