class Object
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end

class Array

  def search_for(str)
    coords = []
    (self.length - 1).times do |y|
      (self[y].length - 1).times do |x|
        if self[y][x] == str
          coords << {x: x, y: y}
        end
      end
    end
    coords
  end

end

class String
# 1 bold
# 4 underline
# 7 invert
#
# Single digits -
# #0 Black
# #1 Red
# #2 Green
# #3 Yellow
# #4 Blue
# #5 Magenta
# #6 Cyan
# #7 White
#
# Text
# 3# - Normal
# 9# - Light
# Backgrounds
# 4# - Normal
# 10# - Light
  def uncolor
    self[self.index("\e")..self.index("m")] = "" if self.include?("\e")
    self[0]
  end

  def is_solid?
    %w(
      #
      ▒
    ).include?(self.uncolor.split.join)
  end

  def is_unbreakable?
    %w(
      ▒
      >
      <
    ).include?(self.uncolor.split.join)
  end
end
