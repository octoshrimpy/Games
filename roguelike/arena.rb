class Arena
  attr_reader :left, :right, :top, :bottom

  def initialize
    @arena = Hash.new {|h,k| h[k]=Hash.new(TILESET[:WALL])}
    @left = @right = @top = @bottom = 0
  end

  def [](x,y)
    @arena[y][x]
  end

  def []=(x,y,v)
    @arena[y][x]=v
    @left = [@left, x].min
    @right = [@right, x].max
    @top = [@top, y].min
    @bottom = [@bottom, y].max
  end

  def to_s
    to_array.collect {|row| row.join}.join("\n")
  end

  def to_array
    (top-1..bottom+1).collect do |y|
      (left-1..right+1).collect do |x|
        self[x,y]
      end
    end
  end
end
