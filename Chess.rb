class Chess

  def initialize
    @running = true
    @whitecell = ". "
    @blackcell = "  "
    @highlight = "O "
    @board = Array.new(24) { Array.new(24) {@whitecell} }
    @white = ["N ","B ","T ","R ","Q ","K "]
    @black = ["n ","b ","t ","r ","q ","k "]
    @turn = "white"
    @error = ""
    # Pawn = N
    # Bishop = B
    # Knight/Horse = T
    # Rook/Castle = R
    # Queen = Q
    # King = K
    #  White uppercase - Black lowercase
  end

  def start
    boardNew
    drawPiece("a1", "R ")
    drawPiece("b1", "T ")
    drawPiece("c1", "B ")
    drawPiece("e1", "Q ")
    drawPiece("d1", "K ")
    drawPiece("f1", "B ")
    drawPiece("g1", "T ")
    drawPiece("h1", "R ")
    drawPiece("f7", "N ")
    drawPiece("c2", "N ")

    drawPiece("a8", "r ")
    drawPiece("b8", "t ")
    drawPiece("c8", "b ")
    drawPiece("e8", "q ")
    drawPiece("d8", "k ")
    drawPiece("f8", "b ")
    drawPiece("g8", "t ")
    drawPiece("h8", "r ")
    # drawPiece("f7", "n ")
    drawPiece("c7", "n ")
    turn
  end

  def pieceRules(from, piece) #From in 24
    rules = []
    8.times do |pos|
      rules[pos] = []
    end
    case piece
    when "N "
      rules[0] = [[0,1]]
      exceptions = [[0,2],[1,1],[-1,1]]
    when "n "
      rules[0] = [[0,-1]]
      exceptions = [[0,-2],[1,-1],[-1,-1]]
    when "R ", "r "
      8.times do |pos|
        rules[0] << [0,pos]
        rules[1] << [pos+1,0]
        rules[2] << [0,-pos]
        rules[3] << [-pos+1,0]
      end
    when "B ", "b "
      8.times do |pos|
        rules[0] << [pos,pos]
        rules[1] << [-pos,pos]
        rules[2] << [pos,-pos]
        rules[3] << [-pos,-pos]
      end
    when "T ", "t "
      rules[0] = [[1,2]]
      rules[1] = [[1,-2]]
      rules[2] = [[2,1]]
      rules[3] = [[2,-1]]
      rules[4] = [[-1,2]]
      rules[5] = [[-1,-2]]
      rules[6] = [[-2,1]]
      rules[7] = [[-2,-1]]
    when "Q ", "q "
      8.times do |pos| # Reverse string detection upward collision
        rules[0] << [pos,pos]
        rules[1] << [-pos,pos]
        rules[2] << [pos,-pos]
        rules[3] << [-pos,-pos]
        rules[4] << [0,pos]
        rules[5] << [pos+1,0]
        rules[6] << [0,-pos]
        rules[7] << [-pos+1,0]
      end
    when "k "
      rules[0] = [[1,1]]
      rules[1] = [[1,0]]
      rules[2] = [[1,-1]]
      rules[3] = [[-1,1]]
      rules[4] = [[-1,0]]
      rules[5] = [[-1,-1]]
      rules[6] = [[0,1]]
      rules[7] = [[0,-1]]
      # exceptions = @white.each
    when "K "
      rules[0] = [[1,1]]
      rules[1] = [[1,0]]
      rules[2] = [[1,-1]]
      rules[3] = [[-1,1]]
      rules[4] = [[-1,0]]
      rules[5] = [[-1,-1]]
      rules[6] = [[0,1]]
      rules[7] = [[0,-1]]
      # exceptions = @black.each
    end
    allowed = []
    rules.each do |form|
      broken = false
      (form.uniq-[[0,0]]).each do |coord|
        new_coord = [coord[0]*3,coord[1]*3]
        x = new_coord[0] + from[0]
        y = new_coord[1] + from[1]
        if x < 24 && x >= 0 && !(broken)
          if y < 24 && y >= 0 && !(broken)
            if @turn == "white"
              allowed << [x, y] if !(@white.include?(@board[x][y]))
            else
              allowed << [x, y] if !(@black.include?(@board[x][y]))
            end
            if !(@board[x][y] == @whitecell || @board[x][y] == @blackcell)
              broken = true
            end
          end
        end
      end
    end
    return allowed.uniq
  end

  def highlight(coords, doit)
    if doit == true
      coords.each do |coord|
        @board[coord[0]+1][coord[1]] = @highlight
        @board[coord[0]-1][coord[1]] = @highlight
        @board[coord[0]][coord[1]+1] = @highlight
        @board[coord[0]][coord[1]-1] = @highlight
      end
    else
      coords.each do |coord|
        boardClean([
          [coord[0]+1,coord[1]],
          [coord[0]-1,coord[1]],
          [coord[0],coord[1]+1],
          [coord[0],coord[1]-1]
        ])
      end
    end
    draw
  end

  def boardNew
    @board.each_with_index do |arr, x|
      arr.length.times do |y|
        if (x / 3) % 2 == (y / 3) % 2
          @board[x][y] = @blackcell
        end
      end
    end
  end

  def boardClean(coords)
    coords.each do |coord|
      x = coord[0].to_i
      y = coord[1].to_i
      if (x / 3) % 2 == (y / 3) % 2
        @board[x][y] = @blackcell
      else
        @board[x][y] = @whitecell
      end
    end
  end



  def board(old_coord, new_coord, piece)
    #is_allowed(old_coord, new_coord, piece)
    #old_coord = -1,-1
    #new_coord = piece
  end

  def is_allowed(old_coord, new_coord, piece)
    #is_legal?
    #is_open?
  end

  def is_open(coord)
    #Check if not taken
  end

  def drawPiece(input, piece)
    coord = inputToCoord(input)
    @board[coord[0]][coord[1]] = piece
  end

  def movePiece(from, to)
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    boardClean([from])
  end

  def inputToCoord(input)
    output = []
    alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
                "N","O","P","R","Q","S","T","U","V","W","X","Y","Z"]
    if input.is_a?(Integer)
      output = (alphabet[input.to_i+1])
    else
      input.reverse! if /\A[-+]?\d+\z/ === input[0]
      input = input.split("") if input.is_a?(String)
      input.each do |change|
        if (/\A[-+]?\d+\z/ === change)
          output <<  (change.to_i)*3 - 2
        else
          output <<  (alphabet.index(change.upcase) + 1)*3 - 2
        end
      end
    end
    return output
  end

  def cheat
    highlight([[13,13]], true)
    highlight([[13,13]], false)
  end

  def crownPawn(type, y)
    puts "A pawn has reached the end!"
    puts "Type a letter representing the piece you would like."
    input = (gets.chomp)
    input = input[0].upcase + " "
    if @white.include?(input)
      @board[y*3-2][22] = input
      puts "#{y*3-2}, #{22}"
    end
  end

  def turn
    draw
    if @turn == "white"
      #Check if King is safe
      8.times do |y|
        if @board[y*3-2][22] == "N "
          crownPawn("white", y)
          draw
        end
      end
      puts "#{@error}"
      @error = ""
      puts "White- Your Turn"
      input_from = (gets.chomp)
      from = inputToCoord(input_from)
      piece = @board[from[0]][from[1]]
      if @white.include?(piece)
        allowed = pieceRules(from, piece)
        if allowed.length > 0
          highlight(allowed, true)
          puts "White- Type the space you would like to go to."
          input_to = (gets.chomp)
          to = inputToCoord(input_to)
          if allowed.include?(to)
            movePiece(from, to)
            highlight(allowed, false)
            @turn = "black"
          else
            @error = "Invalid Move."
            highlight(allowed, false)
          end
        else
          @error = "No possible moves for that piece."
        end
      else
        @error = "Invalid Choice."
      end
    elsif @turn == "black"
      #Check if King is safe
      8.times do |y|
        if @board[y*3-2][1] == "n "
          crownPawn("black", y)
          draw
        end
      end
      puts "#{@error}"
      @error = ""
      puts "Black- Your Turn"
      input_from = (gets.chomp)
      from = inputToCoord(input_from)
      piece = @board[from[0]][from[1]]
      if @black.include?(piece)
        allowed = pieceRules(from, piece)
        if allowed.length > 0
          highlight(allowed, true)
          puts "Black- Type the space you would like to go to."
          input_to = (gets.chomp)
          to = inputToCoord(input_to)
          if allowed.include?(to)
            movePiece(from, to)
            highlight(allowed, false)
            @turn = "white"
          else
            highlight(allowed, false)
            @error = "Invalid Move."
          end
        else
          @error = "No possible moves for that piece."
        end
      else
        @error = "Invalid Choice."
      end
    end
  end

  def draw
    system "clear" or system "cls"
    i = 0
    print "\n         "
    while i < @board.length / 3
      print "   " + (i + 1).to_s + "     "
      i += 1
    end
    puts "\n\n"
    i = 0
    while i < @board.length
      if i % 3 == 1
        print "   " + inputToCoord(i/3 - 1) + "     "
      else
        print "         "
      end
      puts @board[i].join(" ")
      i += 1
    end
    puts "\n\n"
  end
end

game = Chess.new
game.start

loop do
  if game.instance_variable_get(:@running) == true
    game.turn
  else
    break
  end
end
