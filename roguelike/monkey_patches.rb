class Object
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end

class Module
  def class_accessible(*attribute_names)
    attribute_names.each do |attribute_name|
      define_singleton_method(attribute_name) do
        class_variable_get("@@#{attribute_name}")
      end
      define_singleton_method("#{attribute_name}=") do |val|
        class_variable_set("@@#{attribute_name}", val)
      end
    end
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
  def is_color
    if self.include?("\e")
      self[self.index("\e")..self.index("m")]
    else
      "\e[0m"
    end
  end

  def override_foreground_with(color)
    self.gsub /\[(3|9)\d/, "[#{sym_to_escape(color, 'text')}"
  end
  def override_background_with(color)
    self.gsub /[4|10]\dm/, "#{sym_to_escape(color, 'back')}m"
  end

  def sym_to_escape(color, type)
    swab = case color
    when :black then ["30", "40"]
    when :red then ["31", "41"]
    when :green then ["32", "42"]
    when :yellow then ["33", "43"]
    when :blue then ["34", "44"]
    when :magenta then ["35", "45"]
    when :cyan then ["36", "46"]
    when :white then ["37", "47"]
    when :light_black then ["90", "100"]
    when :light_red then ["91", "101"]
    when :light_green then ["92", "102"]
    when :light_yellow then ["93", "103"]
    when :light_blue then ["94", "104"]
    when :light_magenta then ["95", "105"]
    when :light_cyan then ["96", "106"]
    when :light_white then ["97", "107"]
    else nil
    end
    return color if swab == nil
    type == 'text' ? swab[0] : swab[1]
  end

  def color(color, background="")
    old_color = self.is_color
    color_text = sym_to_escape(color, 'text')
    color_background = sym_to_escape(background, 'back')
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
