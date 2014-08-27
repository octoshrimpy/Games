#cd C:\Ruby193\Scripts

# cond ? T : F

require 'io/console'

class Boxes

  def initialize
    @cx = 0
    @cy = 0
    @boardy = 20
    @boardx = 20
    @board = Array.new(@boardy) {Array.new(@boardx, ". ")}
    @board[@cy][@cx] = "X "
    @box = "o "
    @wall = "G "
  end

  def await
    movement(STDIN.getch.downcase)
  end

  def movement(m)
  @board[@cy][@cx] = ". "
    if m == "a" #Move left
      @cx = ((@cx - 1) % @boardx)
    end
    if m == "w" #Move up
      @cy = ((@cy - 1) % @boardy)
    end
    if m == "d" #Move right
      @cx = ((@cx + 1) % @boardx)
    end
    if m == "s" #Move down
      @cy = ((@cy + 1) % @boardy)
    end
    if m == "x"
      system("stty -raw echo")
      exit
    end
    @board[@cy][@cx] = "X "
    show
    sleep 0.1
  end

  def show
    system("stty -raw echo")
    system "clear" or system "cls"
    i = 0
    while i < @boardx
      puts @board[i].join
      i += 1
    end
    system("stty raw -echo")
  end
end

game = Boxes.new
game.show
loop do
    game.await
end
