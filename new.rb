module Mixin
  attr_accessor :coord

  def initialize(num)
    self.coord = num
    self.x = 5
  end
end

class Item
  include Mixin
  attr_accessor :x
end

item = Item.new(9)
puts item.coord
puts item.x
