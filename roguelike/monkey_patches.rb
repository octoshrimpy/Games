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

  def is_color
    if self.include?("\e")
      self[self.index("\e")..self.index("m")]
    else
      "\e[0m"
    end
  end

  def color(color, background="")
    old_color = self.is_color
    color_text = case color
    when :black then "30"
    when :red then "31"
    when :green then "32"
    when :yellow then "33"
    when :blue then "34"
    when :magenta then "35"
    when :cyan then "36"
    when :white then "37"
    when :light_black then "90"
    when :light_red then "91"
    when :light_green then "92"
    when :light_yellow then "93"
    when :light_blue then "94"
    when :light_magenta then "95"
    when :light_cyan then "96"
    when :light_white then "97"
    else nil
    end
    color_background = case background
    when :black then "40"
    when :red then "41"
    when :green then "42"
    when :yellow then "43"
    when :blue then "44"
    when :magenta then "45"
    when :cyan then "46"
    when :white then "47"
    when :light_black then "100"
    when :light_red then "101"
    when :light_green then "102"
    when :light_yellow then "103"
    when :light_blue then "104"
    when :light_magenta then "105"
    when :light_cyan then "106"
    when :light_white then "107"
    else nil
    end
    new_str = ""
    if color_text || color_background
      new_str << "\e[#{color_text}"
      new_str << ";" if color_text && color_background
      new_str << "#{color_background}m"
    end
    new_str << "#{self}#{old_color}"
    new_str
  end

  def uncolor
    while self.include?("\e")
      self[self.index("\e")..self.index("m")] = "" if self.include?("\e")
    end
    self
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
