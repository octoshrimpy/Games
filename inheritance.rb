module Item
  def name
    puts "I am an item"
  end
end

class Foo
  def talk
    puts 'Hello'
  end

  def iam
    puts "Name: #{my_name}"
    puts self.class
  end
end

class Bar < Foo
  include Item

  def iam
    puts 'hello'
    super
  end
end

class Baz < Bar
  attr_accessor :my_name
end

baz = Baz.new
baz.my_name = "Rocco"
baz.iam
# => hello
# => Baz
baz.talk
# => Hello
baz.name
# => "I am an item"
