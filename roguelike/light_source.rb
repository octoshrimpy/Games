class LightSource
  include Item

  attr_accessor :range, :duration, :is_lighting

  def update_vision
    self.is_lighting = Visible.new(Dungeon.current, {x: x, y: y}, range).find_visible
  end

  def calculate_times(percentage)
    this_range, val = self.range, self.duration
    times = {this_range.to_s => val}
    until this_range == 1
      this_range -= 1
      val *= percentage
      times[this_range.to_s] = val
    end
    times
  end

  def initialize(range, duration, coords)
    self.range = range
    self.duration = duration
    @times = calculate_times(0.3)
    self.x = coords[:x]
    self.y = coords[:y]
    self.depth = coords[:depth]
    self.update_vision
    $light_sources[depth] ||= []
    $light_sources[depth] << self
  end

  def self.all; $light_sources.compact.flatten; end
  def self.on_board; $light_sources[Player.depth] || []; end
  def self.find_visible; on_board.map { |light| light.is_lighting }.flatten; end

  def self.tick; all.select { |light| light && !([light.x, light.y, light.depth] == [nil]*3) }.each(&:tick); end

  def destroy
    $screen_shot_objects.delete({instance: self, x: self.x, y: self.y, depth: self.depth})
    $light_sources[depth].delete(self)
  end

  def tick
    self.duration -= 1
    @times.each do |time, tick|
      next if time.to_i > range
      next if time.to_i < range
      if self.duration <= tick
        self.range -= 1
        self.update_vision
      end
    end
    self.destroy if duration <= 0
  end
end
