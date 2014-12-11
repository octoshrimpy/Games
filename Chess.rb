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
    @allow = true
    @error = ""
    @specialWhite = true
    @specialBlack = true
    @condition = false
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
    # drawPiece("b1", "T ")
    # drawPiece("c1", "B ")
    drawPiece("e1", "Q ")
    drawPiece("d1", "K ")
    # drawPiece("f1", "B ")
    # drawPiece("g1", "T ")
    drawPiece("h1", "R ")

    # drawPiece("a2", "N ")
    # drawPiece("b2", "N ")
    # drawPiece("c2", "N ")
    # drawPiece("d2", "N ")
    # drawPiece("e2", "N ")
    # drawPiece("f2", "N ")
    # drawPiece("g2", "N ")
    # drawPiece("h2", "N ")

    # drawPiece("a7", "n ")
    # drawPiece("b7", "n ")
    # drawPiece("c7", "n ")
    # drawPiece("d7", "n ")
    # drawPiece("e7", "n ")
    # drawPiece("f7", "n ")
    # drawPiece("g7", "n ")
    # drawPiece("h7", "n ")

    drawPiece("a8", "r ")
    # drawPiece("b8", "t ")
    # drawPiece("c8", "b ")
    drawPiece("e8", "q ")
    drawPiece("d8", "k ")
    # drawPiece("f8", "b ")
    # drawPiece("g8", "t ")
    drawPiece("h8", "r ")

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
    when "n "
      rules[0] = [[0,-1]]
    when "R ", "r "
      8.times do |pos|
        rules[0] << [0,pos]
        rules[1] << [pos,0]
        rules[2] << [0,-pos]
        rules[3] << [-pos,0]
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
      8.times do |pos|
        rules[0] << [pos,pos]
        rules[1] << [-pos,pos]
        rules[2] << [pos,-pos]
        rules[3] << [-pos,-pos]
        rules[4] << [0,pos]
        rules[5] << [pos,0]
        rules[6] << [0,-pos]
        rules[7] << [-pos,0]
      end
    when "K ", "k "
      rules[0] = [[1,1]]
      rules[1] = [[1,0]]
      rules[2] = [[1,-1]]
      rules[3] = [[-1,1]]
      rules[4] = [[-1,0]]
      rules[5] = [[-1,-1]]
      rules[6] = [[0,1]]
      rules[7] = [[0,-1]]
    end
    allowed = []
    rules.each do |form|
      broken = false
      (form.uniq-[[0,0]]).each do |coord|
        x = coord[0]*3 + from[0]
        y = coord[1]*3 + from[1]
        if x < 24 && x >= 0 && !(broken)
          if y < 24 && y >= 0 && !(broken)
            if piece == piece.upcase
              allowed << [x, y] if !(@white.include?(@board[x][y])) || @allow == false
            else
              allowed << [x, y] if !(@black.include?(@board[x][y])) || @allow == false
            end
            if !(@board[x][y] == @whitecell || @board[x][y] == @blackcell)
              broken = true
              broken = false if @allow == false && (@board[x][y] == "K " || @board[x][y] == "k ")
            end
            enemy = @black if piece == "N "
            enemy = @white if piece == "n "
            if (@specialWhite && piece == "K ") || (@specialBlack && piece == "k ") && @condition == true
              oneUp = (@board[from[0]-3][from[1]] == @blackcell) || (@board[from[0]-3][from[1]] == @whitecell)
              twoUp = (@board[from[0]-6][from[1]] == @blackcell) || (@board[from[0]-6][from[1]] == @whitecell)
              allowed << [from[0]-6, from[1]] if oneUp && twoUp
              @condition = [from[0], from[1]]
            end
            if enemy
              if @allow == true
                allowed << [x, y-3] if from[1] == 19 && !(enemy.include?(@board[x][y-3]) || enemy.include?(@board[x][y])) && enemy == @white
                allowed << [x, y+3] if from[1] == 4 && !(enemy.include?(@board[x][y+3]) || enemy.include?(@board[x][y])) && enemy == @black
              else
                allowed << [x-3, y] if x - 3 < 24
                allowed << [x+3, y] if x + 3 < 24
                allowed.delete([x, y])
              end
              allowed << [x-3, y] if enemy.include?(@board[x-3][y]) if x - 3 < 24
              allowed << [x+3, y] if enemy.include?(@board[x+3][y]) if x + 3 < 24
              allowed.delete([x, y]) if enemy.include?(@board[x][y])
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
    special = "?<>',?[]}{=-)(*&^%$#`~{ }."
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
                "N","O","P","R","Q","S","T","U","V","W","X","Y","Z"]
    if !(input =~ regex) == true
      if input.is_a?(Integer)
        output = (alphabet[input.to_i+1])
      else
        input.reverse! if /\A[-+]?\d+\z/ === input[0]
        input = input.split("") if input.is_a?(String)
        input[0..1].each do |change|
          if (/\A[-+]?\d+\z/ === change)
            output <<  (change.to_i)*3 - 2
          else
            output <<  (alphabet.index(change.upcase) + 1)*3 - 2
          end
        end
      end
    end
    return output
  end

  def crownPawn(type, y)
    puts "A pawn has reached the end!"
    puts "Type a letter representing the piece you would like."
    input = (gets.chomp)
    input = input[0].upcase + " " if type == "white"
    input = input[0].downcase + " " if type == "black"
    @board[y*3-2][22] = input if type == "white" && @white.include?(input)
    @board[y*3-2][1] = input if type == "black" && @black.include?(input)
  end

  def toCoord(x)
    return (x+2)/3
  end

  def findAllMoves(who, piece=false, hostile=false)
    all = []
    @board.each_with_index do |pos, x|
      pos.each_with_index do |loc, y|
        if who.include?(loc)
          if hostile == false
            pieceRules([x, y], loc).each do |add|
              all << add if piece == false
              all << [add, [x, y]] if piece == true
            end
          else
            exceptions(pieceRules([x, y], loc), loc).each do |add|
              all << add if piece == false
              all << [add, [x, y]] if piece == true
            end
          end
        end
      end
    end
    return all
  end

  def exceptions(moves, piece)
    accept = []
    if piece == "K " || piece == "k "
      @allow = false
      enemy = piece == "K " ? @black : @white
      moves.each do |move|
        accept << move if !(findAllMoves(enemy).include?(move))
      end
      @allow = true
      return accept
    else
      return moves
    end
  end

  def safeKing
    if @turn == "white"
      friendly = @white
      enemy = @black
      king_is = "K "
    else
      friendly = @black
      enemy = @white
      king_is = "k "
    end
    row = @board.detect{|aa| aa.include?(friendly.last)}
    king = [row.index(friendly.last), @board.index(row)].reverse
    dangerous = findAllMoves(enemy)
    if dangerous.include?(king)
      baddie = []
      findAllMoves(enemy, true).each do |bad|
        baddie << bad[1] if [bad[0][0], bad[0][1]] == king
      end
      @error = "You're in check! Move or defend your King to continue." # by #{@board[baddie[0][0]][baddie[0][1]]} at (#{toCoord(baddie[0][1])}, #{toCoord(baddie[0][0])})"
      @allow = false
      # p findAllMoves(friendly, false, true).include?([baddie[0][0], baddie[0][1]]) #Check if any allies can kill the enemy.
      # p exceptions(pieceRules(king, king_is), king_is).length #Number of possible moves.
      if !(findAllMoves(friendly, false, true).include?([baddie[0][0], baddie[0][1]])) && exceptions(pieceRules(king, king_is), king_is).length == 0
        @error = "Check mate! #{@turn.capitalize} has been defeated." # by #{@board[baddie[0][0]][baddie[0][1]]} at (#{toCoord(baddie[0][1])}, #{toCoord(baddie[0][0])})"
        @running = false
      end
      @allow = true
      return false
    else
      return true
    end
  end

  def turn
    draw
    if @turn == "white"
      friendly = @white
      enemy = @black
    else
      friendly = @black
      enemy = @white
    end
    # p safeKing
    # if safeKing
      can_move = false
      @board.each_with_index do |x, pos|
        x.each_with_index do |y, loc|
          if friendly.include?(y)
            can_move = true if pieceRules([loc, pos], y).length > 0
          end
        end
      end
      if can_move == false
        p "No moves!"
        @running = false
      end
      8.times do |y|
        if @board[y*3-2][22] == "N "
          crownPawn("white", y)
          draw
        end
        if @board[y*3-2][1] == "n "
          crownPawn("black", y)
          draw
        end
      end
      puts "#{@error}"
      @error = ""
      puts "#{@turn.capitalize}- Your Turn"
      input_from = (gets.chomp)
      from = inputToCoord(input_from)
      piece = @board[from[0]][from[1]] if from.length > 0
      if friendly.include?(piece)
        @condition = true
        allowed = exceptions(pieceRules(from, piece), piece)
        if allowed.length > 0
          highlight(allowed, true)
          puts "#{@turn.capitalize}- Type the space you would like to go to."
          input_to = (gets.chomp)
          to = inputToCoord(input_to)
          if allowed.include?(to)
            movePiece(from, to)
            p from
            p to
            p @condition
            p "[#{to[0]+3},#{to[1]}],[#{to[0]-3}, #{to[1]}]"
            movePiece([to[0]-3, to[1]], [to[0]+3, to[1]]) if from == @condition
            @condition = false
            if safeKing
              highlight(allowed, false)
              @specialWhite = false if piece == "K " || (piece == "R " && from == [1, 1])
              @specialBlack = false if piece == "k " || (piece == "r " && from == [1, 22])
              if @turn == "white"
                @turn = "black"
              else
                @turn = "white"
              end
            else
              movePiece(to, from)
              highlight(allowed, false)
              @error = "Invalid Move. Protect your King to continue."
            end
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
    # end
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
