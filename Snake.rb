#cd C:\Ruby193\Scripts

# cond ? T : F

require 'io/console'
require 'io/wait'

class MiniGame

  def initialize
    @cx = 5
    @cy = 5
    @lon = 1
    @dir = 0 #0=right, 1=down, 2=left, 3=up
    @boardy = 20
    @boardx = 20
    @board = Array.new(@boardy) {Array.new(@boardx, ". ")}
  end

  def await
    while true
      if $stdin.ready?
        movement($stdin.readline.strip)
      end
    end
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
      exit
    end
    show
  end

  def tick
    await

  end

  def food
    if @x == x && @y == y
      @lon += 1
      if 
    end
  end

  def show
    system "clear" or system "cls"
    i = 0
    while i < @boardx
      puts @board[i].join
      i += 1
    end
  end
end

game = MiniGame.new
game.show
loop do
  sleep(1)
  game.tick
end
