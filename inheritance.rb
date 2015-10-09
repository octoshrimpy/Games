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

  def iam
    puts 'hello'
    super
  end
end

i = Item.new
# i.iam
# => hello
# => Item
# => nil
binding.pry
