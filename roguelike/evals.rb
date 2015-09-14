class Evals
  def self.player_invisible(num); "Player.visibility(#{num})"; end
  def self.unstable_teleportation; "sleep(0.3); Player.coords = Dungeon.find_open_spaces(false).sample; Game.tick; true"; end
  def self.flash(distance=5); "$gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_select_position}' to choose coordinate.\"; false"; end
  def self.resurrect_player; "Player.resurrect"; end

  def self.explode(radius, damage, damage_type); "aoe(#{radius}, 'Item.damage_to_coord(coord, #{damage}, \"#{damage_type}\")'); destroy"; end
  def self.new_dot(duration, damage_per_tick, damage_type, should_destroy=true)
    "DotEffect.new({
      duration: #{duration},
      effector: collided_with,
      damage_type: '#{damage_type}',
      damage_per_tick: #{damage_per_tick}
    }); #{should_destroy ? 'destroy' : ''}"
  end

  def self.split_slime
    "count = 0; range = 10
    slime_coords = Creature['Slime'].map(&:coords)
    (-range + self.y..range + self.y).each do |y|
      (-range + self.x..range + self.x).each do |x|
        count += slime_coords.include?({x: x, y: y}) ? 1 : 0
      end
    end
    distance = Math.distance_between(coords, Player.coords)
    coord = self.possible_moves.sample
    if count <= 3 && distance > 10
      Creature.new('m', :light_green).spawn(coord) if coord && Creature.count <= Game::MAX_ENEMIES + 5
    elsif count <= 5 && distance <= 10
      Creature.new('m', :light_green).spawn(coord) if coord && Creature.count <= Game::MAX_ENEMIES + 10
    end"
  end

  def self.pickup_slime
    "slimes = Item.all_by_name('Slime Ball').select { |i| self.depth == i.depth && self.coords == i.coords }
    slimes.each do |slime|
      slime.destroy
      self.strength += Player.depth
      self.health += Player.depth
    end"
  end
end
