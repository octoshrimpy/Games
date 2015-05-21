require 'gosu'

class GameScreen < Gosu::Window
  WIDTH=1000.00
  HEIGHT=400.00
  CANNON_RADIUS=15

  def initialize
    super(WIDTH.round, HEIGHT.round, false)
    @img = Gosu::Image.new(self, Circle.new(CANNON_RADIUS), false)
    @projectiles = []
    @projectiles << Arrow.new({x: WIDTH/2, y: HEIGHT, ang: 315.0})
  end

  def current_arrow
    @projectiles.last
  end

  def update
    if button_down?(Gosu::KbSpace)
      current_arrow.power += current_arrow.power < 5 ? 5 : 0.3
    end
    if button_down?(Gosu::KbUp)
      current_arrow.ang -= 2 unless current_arrow.ang < 190
    end
    if button_down?(Gosu::KbDown)
      current_arrow.ang += 2 unless current_arrow.ang > 350
    end
    @projectiles.each do |arrow|
      arrow.move if arrow.hor_vel != 0 || arrow.vert_vel != 0
      @projectiles.delete(arrow) if arrow.x > WIDTH || arrow.y > HEIGHT
    end
  end

  def draw
    @img.draw(WIDTH/2-CANNON_RADIUS, HEIGHT - CANNON_RADIUS, 0)
    @projectiles.each {|arrow| draw_arrow(arrow)}
  end

  def to_radian(angle)
    angle * Math::PI / 180
  end

  def to_degree(radian)
    radian * 180 / Math::PI
  end

  def draw_arrow(arrow)
    radian = to_radian(arrow.ang)
    white = Gosu::Color.argb(0xffffffff)
    endpoint_x = arrow.x + arrow.length * Math::cos(radian)
    endpoint_y = arrow.y + arrow.length * Math::sin(radian)
    draw_line(arrow.x, arrow.y, white, endpoint_x, endpoint_y, white)
  end

  def button_down(id)
    close if id == Gosu::KbEscape || id == Gosu::KbC
  end

  def button_up(id)
    if id == Gosu::KbSpace && current_arrow.power > 0
      current_arrow.fire!
      @projectiles << Arrow.new({x: WIDTH/2, y: HEIGHT, ang: current_arrow.ang})
    end
  end
end

class Circle
  attr_reader :columns, :rows

  def initialize(radius)
    @columns = @rows = radius * 2
    lower_half = (0...radius).map do |y|
      x = Math.sqrt(radius**2 - y**2).round
      right_half = "#{"\xff" * x}#{"\x00" * (radius - x)}"
      "#{right_half.reverse}#{right_half}"
    end.join
    @blob = lower_half.reverse + lower_half
    @blob.gsub!(/./) { |alpha| "\xff\xff\xff#{alpha}"}
  end

  def to_blob
    @blob
  end
end

class Arrow
  attr_accessor :x, :hor_vel, :y, :vert_vel, :ang, :length, :power

  def initialize(pos)
    @x = pos[:x]
    @y = pos[:y]
    @ang = pos[:ang]
    @length = GameScreen::CANNON_RADIUS + 10
    @vert_vel = 0
    @hor_vel = 0
    @power = 0
  end

  def move
    radian = to_radian(@ang)
    white = Gosu::Color.argb(0xffffffff)
    new_x = @x + @hor_vel
    new_y = @y + @vert_vel
    @vert_vel += 0.3
    @ang = to_degree(Math::atan((new_y - @y) / (new_x - @x)))
    @x = new_x
    @y = new_y
  end

  def fire!
    radian = to_radian(@ang)
    @hor_vel = @power * Math::cos(radian)
    @vert_vel = @power * Math::sin(radian)
    @power = 0
  end

  def to_radian(angle)
    angle * Math::PI / 180
  end

  def to_degree(radian)
    radian * 180 / Math::PI
  end
end

window = GameScreen.new
window.show
