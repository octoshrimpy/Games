class Object
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
end

class String
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
    ).include?(self.uncolor.split.join)
  end
end
