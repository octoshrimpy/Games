require 'pry-rails'
ALPHABET = ('a'..'z').to_a + ('A'..'Z').to_a

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

class Player
  class_accessible :x, :y

  @@x = 5
  @@y = 5

  def self.coords
    {x: x, y: y}
  end

  def self.goto(new_coords)
    @@x = new_coords[:x]
    @@y = new_coords[:y]
    coords
  end

end


binding.pry

Player.x
