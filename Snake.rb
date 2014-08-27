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
    @board = Array.new(@boardy) {Array.new(@boardx, ". ")}
  end

  def movement(m)
    if m == "a" #Move left
      @dir = 2
    end
    if m == "w" #Move up
      @dir = 3
    end
    if m == "d" #Move right
      @dir = 0
    end
    if m == "s" #Move down
      @dir = 1
    end
    if m == "x"
      system "stty -raw echo"
      exit
    end
  end

  def tick
    @x += 1 if @dir == 0
    @y += 1 if @dir == 1
    @x -= 1 if @dir == 2
    @y -= 1 if @dir == 3
    @board[@y][@x] = "X "
    show
  end

  def food
    if @x == x && @y == y
      @lon += 1
    end
  end

  def show
    system "stty -raw echo"
    system "clear" or system "cls"
    i = 0
    while i < @boardx
      puts @board[i].join
      i += 1
    end
      system "stty raw -echo"
  end
end

game = Snake.new
game.show

Thread.new do
  loop do
    game.movement(s = STDIN.getch)
  end
end

i = 0
loop do
game.tick
  i += 1
  sleep 0.3
end
