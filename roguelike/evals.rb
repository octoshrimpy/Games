class Evals
  def self.player_invisible(num); "Player.visibility(#{num})"; end
  def self.summon_stone; "Dungeon.current[coords[:y]][coords[:x]] = ': '; LightSource.reevaluate_at(coords)"; end
  def self.player_berserk(num); "Player.berserk!(#{num}); Log.add(\"You've gone berserk!\")"; end
  def self.unstable_teleportation; "sleep(0.3); Player.coords = Dungeon.find_open_spaces(false).sample; Game.tick; true"; end
  def self.flash(distance=5); "Settings.item_range = #{distance}; $gamemode = 'direct_flash'; $message = \"Click the direction you would like to flash. '#{$key_mapping[:select_position]}' to choose coordinate.\"; false"; end
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

  def self.try_to_split_slime
    "chance = self.health >= 10 ? 1 : (10 - self.health) * 2
    if rand(chance) == 0 && Creature.count < Game::MAX_ENEMIES
      coord = self.possible_moves(false).sample
      if coord
        slime = Creature.new('m', :light_green).spawn(coord)
        slime.health += (self.health / 2).ceil
        self.health = (self.health / 2).ceil
      end
      @can_move = !coord
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
