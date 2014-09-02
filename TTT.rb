#cd C:\Ruby193\Scripts
class Game

require 'pry'
	#Initialize Variables
	def initialize
		@one = 1
		@two = 2
		@three = 3
		@four = 4
		@five = 5
		@six = 6
		@seven = 7
		@eight = 8
		@nine = 9
		@turn = rand(2)
		@h = 0
		@show = 0
		@choose = 0
		@turn = 0
		@round = 0
		@diff = -1 #Difficulty  , 0 = 2 player, 1 = Easy, 2 = Medium, 3 = Hard, 4 = Expert
		@victory = 'Cat'
	end

	def dis_board()
		puts " #{@one} / #{@two} / #{@three} "
		puts " #{@four} / #{@five} / #{@six} "
		puts " #{@seven} / #{@eight} / #{@nine} "
	end

	def your_turn()
		dis_board()
		puts "Player 1: Type the number of the place you want to mark."
		plchoose = gets.chomp.to_i
		if plchoose == 1 && @one == 1
			@one = "O"
		elsif plchoose == 2 && @two == 2
			@two = "O"
		elsif plchoose == 3 && @three == 3
			@three = "O"
		elsif plchoose == 4 && @four == 4
			@four = "O"
		elsif plchoose == 5 && @five == 5
			@five = "O"
		elsif plchoose == 6 && @six == 6
			@six = "O"
		elsif plchoose == 7 && @seven == 7
			@seven = "O"
		elsif plchoose == 8 && @eight == 8
			@eight = "O"
		elsif plchoose == 9 && @nine == 9
			@nine = "O"
		else
			system "clear" or system "cls"
			puts "Error: Not listed or already chosen."
			return
		end
		system "clear" or system "cls"
		puts "You marked #{plchoose}"
		@turn = 1
	end

	def com_turn()
		if @diff != 0
			com_ai
			if @choose == 1 && @one == 1
				@one = "X"
			elsif @choose == 2 && @two == 2
				@two = "X"
			elsif @choose == 3  && @three == 3
				@three = "X"
			elsif @choose == 4  && @four == 4
				@four = "X"
			elsif @choose == 5  && @five == 5
				@five = "X"
			elsif @choose == 6  && @six == 6
				@six = "X"
			elsif @choose == 7  && @seven == 7
				@seven = "X"
			elsif @choose == 8  && @eight == 8
				@eight = "X"
			elsif @choose == 9  && @nine == 9
				@nine = "X"
			else
				return
			end
		else
			puts "Computer turn: Negative."
			return
		end
		if @choose != 0
			puts "Your opponent marked #{@choose}"
			@choose = 0
			@turn = 0
		end
	end

	def smartmove
		if @round == 0
			if (@one == 1 && @two == 2 && @three == 3 && @four == 4 && @five == 5 && @six == 6 && @seven == 7 && @eight == 8 && @nine == 9)
					@choose = rand(1..9)
			elsif @five == "O"
					@choose = [1, 3, 7, 9].sample
			elsif (@one == "O" || @three == "O" || @seven == "O" || @nine == "O")
				@choose = 5
			end
		end
		if @round == 1
			if (@one == "O" && @nine == "O") || (@one == "O" && @seven == "O") || (@three == "O" && @seven == "O")
				@choose = 4
			elsif (@one == "O" && @three == "O")
				@choose = 2
			elsif (@nine == "O" && @three == "O")
				@choose = 6
			elsif (@nine == "O" && @seven == "O")
				@choose = 8
			else
				smartchoose
				smartblock
			end
		end
		if @round > 1
			smartwin
			smartblock if @choose == 0
			smartchoose if @choose == 0
			@choose = rand(1..9) if @choose == 0
			if @choose == 0 && @round < 10
				puts "Error: No moves maybe?"
				return
			elsif @choose == 0
				puts "Fatal error: Exiting"
				exit
			end
		end
	end

	def smartwin
		@choose = case
			when (@three == 3 && (@one == "X" && @two == "X")) then 3
			when (@two == 2 && (@one == "X" && @three == "X")) then 2
			when (@one == 1 && (@two == "X" && @three == "X")) then 1
			when (@six == 6 && (@four == "X" && @five == "X")) then 6
			when (@four == 4 && (@five == "X" && @six == "X")) then 4
			when (@five == 5 && (@four == "X" && @six == "X")) then 5
			when (@nine == 9 && (@seven == "X" && @eight == "X")) then 9
			when (@eight == 8 && (@seven == "X" && @nine == "X")) then 8
			when (@seven == 7 && (@eight == "X" && @nine == "X")) then 7 #End of Horz
			when (@seven == 7 && (@one == "X" && @four == "X")) then 7
			when (@four == 4 && (@one == "X" && @seven == "X")) then 4
			when (@one == 1 && (@four == "X" && @seven == "X")) then 1
			when (@eight == 8 && (@two == "X" && @five == "X")) then 8
			when (@five == 5 && (@two == "X" && @eight == "X")) then 5
			when (@two == 2 && (@five == "X" && @eight == "X")) then 2
			when (@nine == 9 && (@three == "X" && @six == "X")) then 9
			when (@six == 6 && (@three == "X" && @nine == "X")) then 6
			when (@three == 3 && (@six == "X" && @nine == "X")) then 3 #End of Verts
			when (@nine == 9 && (@one == "X" && @five == "X")) then 9
			when (@five == 5 && (@one == "X" && @nine == "X")) then 5
			when (@one == 1 && (@five == "X" && @nine == "X")) then 1
			when (@seven == 7 && (@three == "X" && @five == "X")) then 7
			when (@five == 5 && (@three == "X" && @seven == "X")) then 5
			when (@three == 3 && (@five == "X" && @seven == "X")) then 3
			else return @choose = 0
		end
	end

	def smartchoose
		@choose = case
			when (@one == "X" && (@five == 5 && @nine == 9)) then 9 #If no strings, make a string
			when (@three == "X" && (@five == 5 && @seven == 7)) then 7
			when (@seven == "X" && (@five == 5 && @three == 3)) then 3
			when (@nine == "X" && (@five == 5 && @one == 1)) then 1
			when (@one == "X" && (@four == 4 && @seven == 7)) then 7
			when (@two == "X" && (@five == 5 && @eight == 8)) then 8
			when (@three == "X" && (@six == 6 && @nine == 9)) then 9
			when (@seven == "X" && (@one == 1 && @four == 4)) then 1
			when (@eight == "X" && (@two == 2 && @five == 5)) then 2
			when (@nine == "X" && (@three == 3 && @six == 6)) then 3
			when (@one == "X" && (@two == 2 && @three == 3)) then 3
			when (@four == "X" && (@five == 5 && @six == 6)) then 6
			when (@seven == "X" && (@eight == 8 && @nine == 9)) then 9
			when (@three == "X" && (@one == 1 && @two == 2)) then 1
			when (@six == "X" && (@four == 4 && @five == 5)) then 4
			when (@nine == "X" && (@seven == 7 && @eight == 8)) then 7
		#when (@ == "X" && (@ ==  && @ == )) then
			else return @choose = 0
		end
	end

	def smartblock
		@choose = case
			when (@three == 3 && (@one == "O" && @two == "O")) then @choose = 3
			when (@two == 2 && (@one == "O" && @three == "O")) then @choose =  2
			when (@one == 1 && (@two == "O" && @three == "O")) then @choose =  1
			when (@six == 6 && (@four == "O" && @five == "O")) then @choose =  6
			when (@four == 4 && (@five == "O" && @six == "O")) then @choose =  4
			when (@five == 5 && (@four == "O" && @six == "O")) then @choose =  5
			when (@nine == 9 && (@seven == "O" && @eight == "O")) then @choose =  9
			when (@eight == 8 && (@seven == "O" && @nine == "O")) then @choose =  8
			when (@seven == 7 && (@eight == "O" && @nine == "O")) then @choose =  7 #End of Horz
			when (@seven == 7 && (@one == "O" && @four == "O")) then @choose =  7
			when (@four == 4 && (@one == "O" && @seven == "O")) then @choose =  4
			when (@one == 1 && (@four == "O" && @seven == "O")) then @choose =  1
			when (@eight == 8 && (@two == "O" && @five == "O")) then @choose =  8
			when (@five == 5 && (@two == "O" && @eight == "O")) then @choose =  5
			when (@two == 2 && (@five == "O" && @eight == "O")) then @choose =  2
			when (@nine == 9 && (@three == "O" && @six == "O")) then @choose =  9
			when (@six == 6 && (@three == "O" && @nine == "O")) then @choose =  6
			when (@three == 3 && (@six == "O" && @nine == "O")) then @choose =  3 #End of Verts
			when (@nine == 9 && (@one == "O" && @five == "O")) then @choose =  9
			when (@five == 5 && (@one == "O" && @nine == "O")) then @choose =  5
			when (@one == 1 && (@five == "O" && @nine == "O")) then @choose =  1
			when (@seven == 7 && (@three == "O" && @five == "O")) then @choose =  7
			when (@five == 5 && (@three == "O" && @seven == "O")) then @choose =  5
			when (@three == 3 && (@five == "O" && @seven == "O")) then @choose =  3
			else return @choose = 0
		end
	end

	def com_ai
		if @diff == 1
			@choose = rand(1..9)
		elsif @diff == 2
			smartblock


			@choose = rand(1..9) if @choose == 0
		elsif @diff == 3
			smartwin
			smartblock if @choose == 0
			smartchoose if @choose == 0
			@choose = rand(1..9) if @choose == 0
			puts "No moves!! Ahh!" if @choose == 0
		elsif @diff == 4
			smartmove
			@round += 1
		elsif @diff == 0
			puts "Players is only 1!"
			exit
		end
		return @choose
	end

	def my_turn()
		if @diff == 0
			dis_board()
			puts "Player 2: Type the number of the place you want to mark."
			plchoose = gets.chomp.to_i
			if plchoose == 1 && @one == 1
				@one = "X"
			elsif plchoose == 2 && @two == 2
				@two = "X"
			elsif plchoose == 3 && @three == 3
				@three = "X"
			elsif plchoose == 4 && @four == 4
				@four = "X"
			elsif plchoose == 5 && @five == 5
				@five = "X"
			elsif plchoose == 6 && @six == 6
				@six = "X"
			elsif plchoose == 7 && @seven == 7
				@seven = "X"
			elsif plchoose == 8 && @eight == 8
				@eight = "X"
			elsif plchoose == 9 && @nine == 9
				@nine = "X"
			else
				system "clear" or system "cls"
				puts "Error: Not listed or already chosen."
				return
			end
			system "clear" or system "cls"
			puts "You marked #{plchoose}"
			@turn = 0
		else
			puts "It's not my turn!"
			com_turn()
			return
		end
	end

	def decide()
		horz = 0
		vertz = 0
		diag = 0
		#Horizontal Wins Player
		horz = case
			when (@one == "O" && @two == "O" && @three == "O") then true
			when (@four == "O" && @five == "O" && @six == "O") then true
			when  (@seven == "O" && @eight == "O" && @nine == "O") then true
		end
		#Vertical Wins Player
		vertz = case
			when (@one == "O" && @four == "O" && @seven == "O") then true
			when (@two == "O" && @five == "O" && @eight == "O") then true
			when (@three == "O" && @six == "O" && @nine == "O") then true
		end
		#Diagonal Wins Player
		diag = case
			when (@one == "O" && @five == "O" && @nine == "O") then true
			when (@three == "O" && @five == "O" && @seven == "O") then true
		end
		if horz || vertz || diag
				@victory = "Player 1"
				@h = 1
				return
		end

			chorz = 0
			cvertz = 0
			cdiag = 0
			#Horizontal Wins Player 2
			horz = case
				when (@one == "X" && @two == "X" && @three == "X") then true
				when (@four == "X" && @five == "X" && @six == "X") then true
				when  (@seven == "X" && @eight == "X" && @nine == "X") then true
			end
			#Vertical Wins Player 2
			vertz = case
				when (@one == "X" && @four == "X" && @seven == "X") then true
				when (@two == "X" && @five == "X" && @eight == "X") then true
				when (@three == "X" && @six == "X" && @nine == "X") then true
			end
			#Diagonal Wins Player 2
			diag = case
				when (@one == "X" && @five == "X" && @nine == "X") then true
				when (@three == "X" && @five == "X" && @seven == "X") then true
			end
			if horz || vertz || diag
					@victory = "Player 2"
					@h = 1
					return
			end
		#Stale mate checker
		unless @one == 1 || @two == 2 || @three == 3 || @four == 4 || @five == 5 || @six == 6 || @seven == 7 || @eight == 8 || @nine == 9
			@h = 1
		end
		#How many players?
		if @diff == -1
			system "clear" or system "cls"
			puts "Which difficulty?"
			puts "0 = 2 player, 1 = Easy, 2 = Medium, 3 = Hard, 4 = Expert"
			@diff = gets.chomp.to_i
			system "clear" or system "cls"
			if @diff >= 0 && @diff <= 4
				puts "You have chosen there to be 2 players." if @diff == 0
				puts "You have chosen EASY difficulty." if @diff == 1
				puts "You have chosen MEDIUM difficulty." if @diff == 2
				puts "You have chosen HARD difficulty." if @diff == 3
				puts "You have chosen EXPERT difficulty." if @diff == 4
			else
				puts "You have entered an invalid statement."
				exit
			end
		end
		#Change Turn
		if @turn == 0
			your_turn()
		elsif @turn == 1 && @diff == 0
			my_turn()
		elsif @turn == 1
			com_turn()
		else
			puts "There has been an invalid turn function."
			exit
		end
	end
end

game = Game.new
while game.instance_variable_get(:@h) == 0
	game.decide()
end

puts "\n\n The final board is: \n\n"
game.dis_board()
puts "\nGame Over! #{game.instance_variable_get(:@victory)} wins!"
