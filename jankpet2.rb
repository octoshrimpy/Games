class Pet
  attr_accessor :age, :awake
  def initialize(name)
    @name = name
    @hunger = 0
    @awake = true
    @happy = 3
    @poo = 0
    @age = 0
    puts @name + " is brought screaming and kicking into this world."
  end

  def check_hunger
    puts @name + " hunger level: " + @hunger.to_s
  end

  def check_happy
    puts @name + " happy level: " + @happy.to_s
  end

  def check_age
    puts @name + " age: " + @age.to_s
  end

  def feed(food)
    if @hunger > 0
      @hunger -= 1
      @poo += 1
      self.sad
      puts @name + " eats some delicious " + food
    else
      puts "Not hungry!"
    end
  end

  def sleep
    if @awake
      @poo += 1
      @awake = false
      puts @name + " went to sleep."
    else
      puts "I swear it's already sleeping."
    end
  end

  def wake
    if @awake
      puts "I swear it's already up."
    else
      @awake = true
      puts @name + " woke up."
    end
  end

  def aging
    @age += 1
    self.sad
    puts @name + " is now one year older!"
  end

  def death
    if @age > 10
      puts @name + " died."
      return -1 #death :(
    end
  end

  def poop
    if @poo > 0
      poo -= 1
      puts @name + " took a shit."
    else
      puts "Nothing to drop."
    end
  end

  def sad
    if @happy > 0
      @happy -= 1
    end
  end

  def play(activity)
    @hunger += 1
    @happy += 1
    puts "You play a thrilling game of " + activity + " with " + @name + "!"
  end

  def chance(range, cutoff)
    if rand(range) > cutoff
      return true
    else
      return false
    end
  end

  def sim
    if !(@awake)
      if chance(100,50)
        self.wake
      else
        puts "ZzzZZZZzzzZ..."
        return
      end
    elsif chance(10,3)
      if @poo > 0
        self.poop
      end
    elsif chance(10,3)
      @hunger += 1
    elsif chance(10,2)
      self.aging
    elsif @awake && chance(100,20)
      self.sleep
    end
    if @poo > 3 || @hunger > 3
      self.sad
    end
    if (@happy == 1 && self.chance(10,5)) || @happy == 0
      @poo += 1
      @hunger += 1
      puts "Please treat the poor thing better :("
    end
    if @hunger > 5
      @poo += 1
      puts "Please feed the poor thing :("
    end
  end
end

food = ["Cheetoes","Mike and Ikes","Sweet and Sour Chicken","Pecan Cookies","Snickerdoodles","Angel Food Cake","Pizza","Spaghetti"]
stuff = ["Hangman","Tic-tac-toe","Human knot","London Bridges","Frog races","Water balloon fights","Silly relay races"]

puts "Weclome to Rubagotchi EMU"
print "What will you creature be called: "
pet = Pet.new(gets.chomp)

until pet.death == -1
  puts "Choose an action (type 'help' for commands): "
  input = gets.chomp
  if !(pet.awake) && input != 'wake'
    puts "Shh, it's sleeping!"
    next
  end
  if input == 'feed'
    pet.feed(food.sample)
  elsif input == 'sleep'
    pet.sleep
  elsif input == 'play'
    pet.play(stuff.sample)
  elsif input == 'wake'
    pet.wake
  elsif input == 'poo'
    pet.poop
  elsif input == 'h'
    pet.check_hunger
    next
  elsif input == 'a'
    pet.check_age
    next
  elsif input == 'l'
    pet.check_happy
    next
  elsif input = 'help'
    puts "Actions words: play, feed, wake, sleep, poo"
    puts "Status words: a, h, l"
    next
  end
  pet.sim
end
