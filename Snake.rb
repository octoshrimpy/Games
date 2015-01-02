  #cd C:\Ruby193\Scripts

# cond ? T : F

require 'io/console'
require 'io/wait'
class Snake

  def initialize
    @x = 5
    @y = 5
    @lon = 1
    @dir = 0 #0=right, 1=down, 2=left, 3=up
    @boardy = 20
    @boardx = 20
    @empty_cell = ". "
    @snake = "O "
    @food_cell = "x "
    @wall = "Q "
    @life = []
    @running = true
    @board = Array.new(@boardy) {Array.new(@boardx, ". ")}
  end

  def died
    system "stty -raw echo"
    puts "You crashed!"
    @running = false
  end

  def movement(m)
    if m == "a" && @dir != 0 && @board[@y][((@x - 1) % @boardx)] != @snake #Move left
      @dir = 2
    end
    if m == "w" && @dir != 1 && @board[((@y - 1) % @boardy)][@x] != @snake #Move up
      @dir = 3
    end
    if m == "d" && @dir != 2 && @board[@y][((@x + 1) % @boardx)] != @snake #Move right
      @dir = 0
    end
    if m == "s" && @dir != 3 && @board[((@y + 1) % @boardy)][@x] != @snake #Move down
      @dir = 1
    end
    if m == "x"
      died
    end
    #if m = "p"
    #  settings #TODO
    #end
  end

  def tick
    a = @x
    b = @y
    @life[@lon-1] = [@x, @y]
    a, b = @life.shift
    @x = ((@x + 1) % @boardx) if @dir == 0 #right
    @x = ((@x - 1) % @boardx) if @dir == 2 #left
    @y = ((@y + 1) % @boardx) if @dir == 1 #down
    @y = ((@y - 1) % @boardx) if @dir == 3 #up
    if @board[@y][@x] == (@snake || @wall)
      show
      died
    end
    if @board[@y][@x] == @food_cell
      @lon += 1
      @life << [@x, @y]
      makefood
    end
    @board[@y][@x] = @snake
    @board[b][a] = @empty_cell
    show
  end

  def makefood
    x = rand(@boardx)
    y = rand(@boardy)
    while @board[y][x] != @empty_cell
      x = rand(@boardx)
      y = rand(@boardy)
    end
    @board[y][x] = @food_cell
  end

  def show
    system "stty -raw echo"
    system "clear" or system "cls"
    i = 0
    while i < @boardx
      puts @board[i].join
      i += 1
    end
    puts "Score: #{@lon}"
    system "stty raw -echo"
  end
end


File.new "./Saves/s_sh.txt", "w+" if !(File.exists?("./Saves/s_sh.txt"))
old = File.read("./Saves/s_sh.txt").to_i
puts "The old high score is: #{old}"
sleep 3
game = Snake.new
game.makefood
game.show

prompt = Thread.new do
  loop do
    game.movement(s = STDIN.getch.downcase)
  end
end

i = 0
loop do
  if game.instance_variable_get(:@running) == true
    game.tick
    i += 1
    sleep 0.15
  else
    prompt = 0
    break
  end
end

prompt = 0
system "stty -raw echo"

if game.instance_variable_get(:@lon) > old
  new_score = game.instance_variable_get(:@lon)
  puts "You have beaten the high score!"
  File.open("./Saves/s_sh.txt", 'w+') { |f| f.puts("#{new_score}") }
else
  puts "No records broken. Your final score is: #{game.instance_variable_get(:@lon)}"
end
puts "#{new_score} is the high score"
File.open("./Saves/s_sh.txt", 'w+') { |f| f.puts("#{new_score}") }

exit
