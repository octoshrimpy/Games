require 'pry-rails'

class Object
  def talk
    puts 'Hello'
  end

  def iam
    puts self.class
  end
end

class Item < Object
end

i = Item.new
binding.pry
