#cd C:\Ruby193\Scripts

# cond ? T : F
#require 'pry'
require 'io/console'

class Boxes

  def initialize
    @cx = 0
    @cy = 0
    @lvl = 1
    @boardy = 0
    @boardx = 0
    @key = "K "
    @box = "o "
    @wall = "G "
    @door = "D "
    @hole = "O "
    @empty = ". "
    @player = "X "
    # @board = Array.new(@boardy) {Array.new(@boardx, @empty)}
    # @board[@cy][@cx] = @player
  end

  def load(lvl)
    loadup = File.read("./Saves/Box_sf.txt").split("\n")#New line is new level
    # 012-Map x 345-Map y 678-9,10,11-Player x,y 111213-number of boxes,141516-number of walls
    #17+ - 012,345-box x,y
    #17+(6*number of boxes) 012,345 extra wall x,y
    #17+(6*box)+(6*wall) 012,345 empty wall(For wrapping)
    if loadup[lvl]
      a = loadup[lvl].split("").each_slice(2).to_a #Takes a string of numbers, splits it into groups of 2
    else
      a = loadup[1].split("").each_slice(2).to_a
      puts "Error: Level maximum reached, reverting back to level 1."
    end
    i = 0
    while i < a.length #Joins groups together
      a[i] = a[i].join
      i += 1
    end
    a = a.map(&:to_i) #converts groups to ints. We now have an array of 3 digit numbers.
    # 0-Wrap true or false, 1,2-Map size 3,4-Player coord 5-num boxes 6-num walls 7-num doors 8 num holes
    #9+ 1,2-boxes x,y
    #10+(2*a[5]) extra walls x,y
    #11+(2*a[5]+2*a[6]) 1,2 empty wall x,y
    # Default walls all around map
    puts a
    @boardx = a[1]
    @boardy = a[2]
    @board = Array.new(a[2]) {Array.new(a[1], @empty)}
    if a[0] == 0 #Wall wrap = true, build walls
      i = 0
      while i < @boardx
        @board[0][i] = @wall
        @board[@boardy-1][i] = @wall
        i += 1
      end
      i = 0
      while i < @boardy
        @board[i][0] = @wall
        @board[i][@boardx-1] = @wall
        i += 1
      end
      puts "Wall borders built."
    end

    i = 0
    while i < a[5]
      @board[a[10+(i*2)]][a[9+(i*2)]] = @box
      puts "Box placed at #{a[9+(i*2)]},#{a[10+(i*2)]}"
      i += 1
    end

    i = 0
    while i < a[6]
      @board[ a[ (10 + (a[5]*2) + (i*2) ) ] ][ a[ (9 + (a[5]*2) + (i*2) ) ] ] = @wall
      puts "Wall placed at #{a[(9 + a[5]*2 + (i*2))]},#{a[(10 + a[5]*2 + (i*2))]}"
      i += 1
    end

    i = 0
    while i < a[7]
      @board[ a[ (10 + (a[5]*2) + (a[6]*2) + (i*2) ) ] ][ a[ (9 + (a[5]*2) + (a[6]*2) + (i*2) ) ] ] = @door
      puts "Door placed at #{a[(9 + (a[5]*2) + (a[6]*2) + (i*2))]},#{a[(10 + (a[5]*2) + (a[6]*2) + (i*2))]}"
      i += 1
    end

    i = 0
    while i < a[8]
      @board[a[(10+(a[5]*2)+(a[6]*2)+(a[7]*2)+(i*2))]][a[(9+(a[5]*2)+(a[6]*2)+(a[7]*2)+(i*2))]] = @hole
      puts "Hole placed at #{a[(9+(a[5]*2)+(a[6]*2)+(a[7]*2)+(i*2))]},#{a[(10+(a[5]*2)+(a[6]*2)+(a[7]*2)+(i*2))]}"
      i += 1
    end
      #a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + (i*2))]},#{a[(10 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (i*2))]


    i = 0
    while a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]
      if a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)] % 2 == 1
        @board[0][a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]] = @empty
        @board[@boardy-1][a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]] = @empty
        puts "Broke through at x = #{a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]}"
      elsif a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)] % 2 == 0
        @board[a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]][0] = @empty
        @board[a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]][@boardx-1] = @empty
        puts "Broke through at y = #{a[(9 + (a[5]*2) + (a[6]*2) + (a[7]*2) + (a[8]*2) + i)]}"
      else
        puts "Something has gone horribly wrong...."
      end
      i += 1
    end
    @cx = a[3]
    @cy = a[4]
    @board[@cy][@cx] == @player
    puts "Player placed at #{@cx},#{@cy}."
  end

  def movement(m)
    @board[@cy][@cx] = ". "

    if m == "a" #Move left
      @cx = ((@cx - 1) % @boardx)
      if @board[@cy][@cx] == @box
        if @board[@cy][((@cx - 1) % @boardx)] == @empty
          @board[@cy][((@cx - 1) % @boardx)] = @box
        elsif @board[@cy][((@cx - 1) % @boardx)] == @hole
          @board[@cy][((@cx - 1) % @boardx)] = @hole
        else
          @cx = ((@cx + 1) % @boardx)
        end
      end
      @cx = ((@cx + 1) % @boardx) if @board[@cy][@cx] == @wall ||
      @board[@cy][@cx] == @hole ||
      @board[@cy][@cx] == @door
    end

    if m == "d" #Move right
      @cx = ((@cx + 1) % @boardx)
      if @board[@cy][@cx] == @box
        if @board[@cy][((@cx + 1) % @boardx)] == @empty
          @board[@cy][((@cx + 1) % @boardx)] = @box
        elsif @board[@cy][((@cx + 1) % @boardx)] == @hole
          @board[@cy][((@cx + 1) % @boardx)] = @hole
        else
          @cx = ((@cx - 1) % @boardx)
        end
      end
      @cx = ((@cx - 1) % @boardx) if @board[@cy][@cx] == @wall ||
      @board[@cy][@cx] == @hole ||
      @board[@cy][@cx] == @door
    end

    if m == "w" #Move up
      @cy = ((@cy - 1) % @boardy)
      if @board[@cy][@cx] == @box
        if @board[((@cy - 1) % @boardy)][@cx] == @empty
          @board[((@cy - 1) % @boardy)][@cx] = @box
        elsif @board[((@cy - 1) % @boardy)][@cx] == @hole
          @board[((@cy - 1) % @boardy)][@cx] = @hole
        else
          @cy = ((@cy + 1) % @boardy)
        end
      end
      @cy = ((@cy + 1) % @boardy) if @board[@cy][@cx] == @wall ||
      @board[@cy][@cx] == @hole ||
      @board[@cy][@cx] == @door
    end

    if m == "s"  #Move down
      @cy = ((@cy + 1) % @boardy)
      if @board[@cy][@cx] == @box
        if @board[((@cy + 1) % @boardy)][@cx] == @empty
          @board[((@cy + 1) % @boardy)][@cx] = @box
        elsif @board[((@cy + 1) % @boardy)][@cx] == @hole
          @board[((@cy + 1) % @boardy)][@cx] = @hole
        else
          @cy = ((@cy - 1) % @boardy)
        end
      end
      @cy = ((@cy - 1) % @boardy) if @board[@cy][@cx] == @wall ||
      @board[@cy][@cx] == @hole ||
      @board[@cy][@cx] == @door
    end

    if m == "x"
      system("stty -raw echo")
      exit
    end

    if m == " "
      if @left == 0
        @lvl += 1
        system("stty -raw echo")
        system "clear" or system "cls"
        load(@lvl)
      end
    end
    @board[@cy][@cx] = "X "
    show
    sleep 0.05
  end

  def show
    puts "Player: #{@cx},#{@cy}."
    system("stty -raw echo")
    system "clear" or system "cls"
    i = 0
    while i < @boardx
      puts @board[i].join
      i += 1
    end
    win_detection
    puts "Boxes remaining: #{@left}"
    puts "Press space to move to next level." if @left == 0
    system("stty raw -echo")
  end

  def win_detection
    @left = 0
    ix = 0
    iy = 0

    while (ix < @boardx) && (iy < @boardy)
      @left += 1 if @board[iy][ix] == @box
      ix += 1
      if ix >= @boardx
        ix = 0
        iy += 1
      end
    end
  end

end

game = Boxes.new
if File.exists?("./Saves/Box_sf.txt")
  game.load(1)
  game.show
else
  puts "Game load error: No save file found."
end

loop do
  game.movement(STDIN.getch.downcase)
end
