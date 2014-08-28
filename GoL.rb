#cd C:\Ruby193\Scripts

#Rules:
# O < 2cnt = X
# O == 2..3cnt = O
# O > 3cnt = X
# X == 3 = O
# O{1X 2O 3O 45678X}
# X{12X 3O 45678X}

=begin
Options:
Settings (y/n)
	Live cell icon
	Dead cell icon
	Life Matrix size, ranged from 5x5 to 79x50
	Wrapping (T/F)
	# of iterations (0-inf)
	Length of iteration (0.01-10)
	Marking individual cells
	Choose random numbers
	Import pre-mades
		Clear screen mode
		Glider
		Pi
		Ants
		R-Pentomino
		Tumbler
		Cow
		Century
		Galaxy
		Line Tool
=end

class GoL
	def initialize
		@x = 20	#Width of the game 1-79
		@y = 20	#Height of the game 1-50
		@maxx = 101
		@maxy = 51
		@live = "O "
		@dead = ". "
		@stable = false
		@board = Array.new(@y) {Array.new(@x, @dead)}#Array used to store the Life Matrix.
		@tboard = Array.new(@y) {Array.new(@x, "t")} #Array used to temporarily store while calculating.
		@copyb = Array.new(@y) {Array.new(@x, "c")} #Array used to check if board repeats every other time (Stable)
		@its = 1 #Iteration checker- ends game at desired time.
		@slp = 0.05 #Step function- indicates how long each tick lasts.
		@cnt = 0 #Count function, used to track how many neighbours a cell has.
		@wrapping = true #Wrapping feature, on by default
	end
	#Array.new(5) {Array.new(5, 5)}
	def scfunc #Pre-made functions
		# Glider, Solid, Checkered, R Pentomino
		puts "Options available:"
		#puts "0: "
		puts "0: Clear the screen."
		puts "1: Glider, a spaceship that continuously travels down to the right."
		puts "2: Pi"
		puts "3: Ants, recommended only if x width is divisible by 5."
		puts "4: R-Pentomino, a design that, given enough room, will become stable after 1103 iterations."
		puts "5: Tumbler, an oscillator that rolls in place."
		puts "6: Cow, an extendible train that will fit to the max screen length."
		puts "7: Century pentomino"
		puts "8: Galaxy, oscillator that resembles a galaxy."
		puts "9: Line tool, used to draw horizontal or vertical lines."

		a = gets.chomp.to_i
		if a == 0 #Clear screen
			@tboard = Array.new(@y) {Array.new(@x, @dead)}
			@board = []
			@board = @tboard
		elsif a == 1 #Glider
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			switch_cell(x+3-2,y+3-2)
			switch_cell(x+2-2,y+3-2)
			switch_cell(x+1-2,y+3-2)
			switch_cell(x+3-2,y+2-2)
			switch_cell(x+2-2,y+1-2)
		elsif a == 2 #Pi
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			switch_cell(x+1-2,y+1-2)
			switch_cell(x+1-2,y+2-2)
			switch_cell(x+1-2,y+3-2)
			switch_cell(x+2-2,y+1-2)
			switch_cell(x+3-2,y+1-2)
			switch_cell(x+3-2,y+2-2)
			switch_cell(x+3-2,y+3-2)
		elsif a == 3 #Ants
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			tx = @x/5
			i = 0
			while i < tx
				i += 1
				switch_cell(x+(1+i*5)-2,y+1-2)
				switch_cell(x+(2+i*5)-2,y+1-2)
				switch_cell(x+(3+i*5)-2,y+2-2)
				switch_cell(x+(4+i*5)-2,y+2-2)
				switch_cell(x+(3+i*5)-2,y+3-2)
				switch_cell(x+(4+i*5)-2,y+3-2)
				switch_cell(x+(1+i*5)-2,y+4-2)
				switch_cell(x+(2+i*5)-2,y+4-2)
			end
		elsif a == 4 #R-Pentommino
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			switch_cell(x+2-2,y+1-2)
			switch_cell(x+3-2,y+1-2)
			switch_cell(x+2-2,y+2-2)
			switch_cell(x+1-2,y+2-2)
			switch_cell(x+2-2,y+3-2)
		elsif a == 5 #Tumbler
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			#y1(2356) y2(2356) y3(35) y4(1357) y5(1357) y6(1267)
			#y1
			switch_cell(x+2-2,y+1-2)
			switch_cell(x+3-2,y+1-2)
			switch_cell(x+5-2,y+1-2)
			switch_cell(x+6-2,y+1-2)
			#y2
			switch_cell(x+2-2,y+2-2)
			switch_cell(x+3-2,y+2-2)
			switch_cell(x+5-2,y+2-2)
			switch_cell(x+6-2,y+2-2)
			#y3
			switch_cell(x+3-2,y+3-2)
			switch_cell(x+5-2,y+3-2)
			#y4
			switch_cell(x+1-2,y+4-2)
			switch_cell(x+3-2,y+4-2)
			switch_cell(x+5-2,y+4-2)
			switch_cell(x+7-2,y+4-2)
			#y5
			switch_cell(x+1-2,y+5-2)
			switch_cell(x+3-2,y+5-2)
			switch_cell(x+5-2,y+5-2)
			switch_cell(x+7-2,y+5-2)
			#y6
			switch_cell(x+1-2,y+6-2)
			switch_cell(x+2-2,y+6-2)
			switch_cell(x+6-2,y+6-2)
			switch_cell(x+7-2,y+6-2)
		elsif a == 6 #Cow
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			tx = (@x-15)/4
			i = 0
			#start y1(23) y2(23810) y3(679) y4(67) y5(679) y6(23810) y7(23)
			switch_cell(x+2-2,y+1-2)
			switch_cell(x+3-2,y+1-2)

			switch_cell(x+2-2,y+2-2)
			switch_cell(x+3-2,y+2-2)
			switch_cell(x+8-2,y+2-2)
			switch_cell(x+10-2,y+2-2)

			switch_cell(x+6-2,y+3-2)
			switch_cell(x+7-2,y+3-2)
			switch_cell(x+9-2,y+3-2)

			switch_cell(x+6-2,y+4-2)
			switch_cell(x+7-2,y+4-2)

			switch_cell(x+6-2,y+5-2)
			switch_cell(x+7-2,y+5-2)
			switch_cell(x+9-2,y+5-2)

			switch_cell(x+2-2,y+6-2)
			switch_cell(x+3-2,y+6-2)
			switch_cell(x+8-2,y+6-2)
			switch_cell(x+10-2,y+6-2)

			switch_cell(x+2-2,y+7-2)
			switch_cell(x+3-2,y+7-2)
			while i < tx
				switch_cell(x+(11+i*4)-2,y+1-2)
				switch_cell(x+(12+i*4)-2,y+1-2)

				switch_cell(x+(11+i*4)-2,y+2-2)
				switch_cell(x+(12+i*4)-2,y+2-2)

				switch_cell(x+(11+i*4)-2,y+4-2)
				switch_cell(x+(12+i*4)-2,y+4-2)
				switch_cell(x+(13+i*4)-2,y+4-2)
				switch_cell(x+(14+i*4)-2,y+4-2)

				switch_cell(x+(11+i*4)-2,y+6-2)
				switch_cell(x+(12+i*4)-2,y+6-2)

				switch_cell(x+(11+i*4)-2,y+7-2)
				switch_cell(x+(12+i*4)-2,y+7-2)
				i += 1
			end
			switch_cell(x+(12+tx*4)-2,y+2-2)
			switch_cell(x+(13+tx*4)-2,y+2-2)

			switch_cell(x+(11+tx*4)-2,y+3-2)
			switch_cell(x+(13+tx*4)-2,y+3-2)

			switch_cell(x+(11+tx*4)-2,y+4-2)

			switch_cell(x+(12+tx*4)-2,y+5-2)

			switch_cell(x+(11+tx*4)-2,y+6-2)
			switch_cell(x+(12+tx*4)-2,y+6-2)
		elsif a == 7 #Century
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			# y1(3,4) y2(1,2,3) y3(2)
			switch_cell(x+3-2,y+1-2)
			switch_cell(x+4-2,y+1-2)

			switch_cell(x+1-2,y+2-2)
			switch_cell(x+2-2,y+2-2)
			switch_cell(x+3-2,y+2-2)

			switch_cell(x+2-2,y+3-2)
		elsif a == 8 #Galaxy
			puts "Please input your starting coordinates, separated by a space."
			c = gets.chomp
			if c.include?(" ")#Checks if there are two numbers.
				c = c.split(" ").map(&:to_i)#Number into array.
				x = c[0]
					if c[1] != nil
						y = c[1]
					else
						y = 0
					end
			else	#One number- used for both coordinates
				x = c.to_i
				y = c.to_i
			end
			x = 1 if x <= 0
			y = 1 if y <= 0
			x = @x if x >= @x
			y = @y if y >= @y
			puts "x = #{x}, y = #{y}"
			# y1(123456 89) y2(123456 89) y3(89) y4(12 89) y5(12 89) y6(12 89) y7(12 89) y8(12 456789) y9(12 456789)
			switch_cell(x+1-2,y+1-2)
			switch_cell(x+2-2,y+1-2)
			switch_cell(x+3-2,y+1-2)
			switch_cell(x+4-2,y+1-2)
			switch_cell(x+5-2,y+1-2)
			switch_cell(x+6-2,y+1-2)
			switch_cell(x+8-2,y+1-2)
			switch_cell(x+9-2,y+1-2)

			switch_cell(x+1-2,y+2-2)
			switch_cell(x+2-2,y+2-2)
			switch_cell(x+3-2,y+2-2)
			switch_cell(x+4-2,y+2-2)
			switch_cell(x+5-2,y+2-2)
			switch_cell(x+6-2,y+2-2)
			switch_cell(x+8-2,y+2-2)
			switch_cell(x+9-2,y+2-2)

			switch_cell(x+8-2,y+3-2)
			switch_cell(x+9-2,y+3-2)

			switch_cell(x+1-2,y+4-2)
			switch_cell(x+2-2,y+4-2)
			switch_cell(x+8-2,y+4-2)
			switch_cell(x+9-2,y+4-2)

			switch_cell(x+1-2,y+5-2)
			switch_cell(x+2-2,y+5-2)
			switch_cell(x+8-2,y+5-2)
			switch_cell(x+9-2,y+5-2)

			switch_cell(x+1-2,y+6-2)
			switch_cell(x+2-2,y+6-2)
			switch_cell(x+8-2,y+6-2)
			switch_cell(x+9-2,y+6-2)

			switch_cell(x+1-2,y+7-2)
			switch_cell(x+2-2,y+7-2)

			switch_cell(x+1-2,y+8-2)
			switch_cell(x+2-2,y+8-2)
			switch_cell(x+4-2,y+8-2)
			switch_cell(x+5-2,y+8-2)
			switch_cell(x+6-2,y+8-2)
			switch_cell(x+7-2,y+8-2)
			switch_cell(x+8-2,y+8-2)
			switch_cell(x+9-2,y+8-2)

			switch_cell(x+1-2,y+9-2)
			switch_cell(x+2-2,y+9-2)
			switch_cell(x+4-2,y+9-2)
			switch_cell(x+5-2,y+9-2)
			switch_cell(x+6-2,y+9-2)
			switch_cell(x+7-2,y+9-2)
			switch_cell(x+8-2,y+9-2)
			switch_cell(x+9-2,y+9-2)
		elsif a == 9 #Line tool
			puts "H or V for Horizontal or Vertical orientation followed by line length number."
			len = gets.chomp.downcase
			lon = 0
			if ["h", "v"].include?(len[0]) #Checks if first letter is H or V
				if len[0] == "h"
					hv = 1
				elsif len[0] == "v"
					hv = 0
				end
				if len.include?(" ") #Checks if a space follows letter
					len = len.split(" ").map(&:to_i) #Separate letter and num
					if len[1] != nil #Verifies there IS a num
						lon = len[1]
					elsif len[1] == nil
						lon = 1
					end
				end
				puts "Please input your starting coordinates, separated by a space."
				c = gets.chomp
				if c.include?(" ")#Checks if there are two numbers.
					c = c.split(" ").map(&:to_i)#Number into array.
					x = c[0]
						if c[1] != nil
							y = c[1]
						else
							y = 0
						end
				else	#One number- used for both coordinates
					x = c.to_i
					y = c.to_i
				end
				x = 1 if x <= 0
				y = 1 if y <= 0
				x = @x if x >= @x
				y = @y if y >= @y
				puts "x = #{x}, y = #{y}"
				i = 0
				while i < lon
					#puts "Open loop"
					if hv == 1
						switch_cell(x+i-1,y-1)
					elsif hv == 0
						switch_cell(x-1,y+i-1)
					end
					i += 1
				end
				#puts "Close loop"
			end
		else
			puts "Invalid statement."
		end
		system "clear" or system "cls"
		show
	#Making a checkerboard pattern.]
		# @tboard = Array.new(@y) {Array.new(@x, @dead)}
		# ix = 0
		# iy = 0
		# while (ix < @x) && (iy < @y)
			# @tboard[iy][ix] = @live
			# ix += 2
			# if ix >= @x
				# iy += 1
				# ix = (iy%2)
			# end
		# @board = @tboard
	end

	def coords #Input coordinates from user for custom blips
		@copyb = []
		@tboard = []
		@stable = false
		sc = 0 #Begins loop to prompt user for functions when true
		h = 0 #Hold variable. Used to keep looping until user is finished.
		while h == 0
			puts "Please type coordinates of spot to mark, separated by a space."
			puts "Type R followed by a space and number to place # of blips randomly."
			puts "Type Function for quick, pre made maps."
			puts "Leave blank to finish. "
			c = gets.chomp.downcase
			if ["f"].include?(c[0])
				sc = 1
			elsif c == ""#Checks to see if no input was given, gets out of loop.
				h = 1
				break
			elsif ["r"].include?(c[0]) #Checks if first letter is R
				if c.include?(" ") #Checks if a space follows R
					c = c.split(" ").map(&:to_i) #Separate R and num
					if c[1] != nil #Verifies there IS a num
						while c[1] > 0#Uses the number, counts down while placing random blips throughout the board.
							"#{c[1]} random blips."
							switch_cell(rand(@x), rand(@y))
							c[1] -= 1
						end
					else
						puts "Error: Expected integer, received string."
					end
				else
					puts"Number not found." #Case of no num after R
					switch_cell(rand(@x), rand(@y))
				end
			elsif ["x"].include?(c[0])
				exit
			else
				if c.include?(" ")#Checks if there are two numbers.
					c = c.split(" ").map(&:to_i)#Number into array.
					cx = c[0]
					if c[1] != nil
						cy = c[1]
					else
						cy = 0
					end
				else	#One number- used for both coordinates
					cx = c.to_i
					cy = c.to_i
				end
				cx = @x if cx >= @x+1 #Max values- coordinates can't be beyond Matrix boundaries.
				cx = 1 if cx < 2
				cy = @y if cy >= @y+1
				cy = 1 if cy < 2
				puts "#{cx},#{cy}"
				switch_cell(cx-1,cy-1)#-1 to convert from abs to rel positions
			end
			while sc == 1#Prompt user for function, then asks for more or to continue
				scfunc
				puts "Would you like to place another function? No default. Y or yes for yes."
				f = gets.chomp.downcase
				if !["y", "yes", "f", "fun", "func", "function", "functions"].include?(f)
					sc = 0
				end
			end
			system "clear" or system "cls"
		show
		end
	end

	def getsiz #Input from user, and builds the Life Matrix.
		puts "Please input a single digit icon for live cells."
		@live = gets.chomp
		@live = " " if @live == ""
		if @live.length > 1
			@live = @live[0] #Sets the char used for the live cells based on user input
		end
		puts "Please input a single digit icon for dead cells."
		@dead = gets.chomp
		@dead = " " if @dead == ""
		if @dead.length > 1
			@dead = @dead[0]#Sets the char used for the dead cells based on user input
		end
		if @live == @dead
			puts "Error: Live and Dead icons are the same. Auto-changing..."
			if @dead != "."
				@live = "." #Changes icon if both live and dead are the same.
			else
				@live = "x"
			end
		end
		@live = @live + " "
		@dead = @dead + " "
		puts "How big? Input two numbers separated by space or 1 number for a square. \nMin = 5x5, Max = 100x50."
		siz = gets.chomp
		puts "\n"
		if siz == "0"
			@x = 0
			@y = 0
		elsif siz.to_i == 0
			puts "Error: String found where expecting integer."
			puts "Using default size of 10x10."
			@x = 10
			@y = 10
		else
			if siz.include?(" ")#Check to see if there are two numbers.
				siz = siz.split(" ").map(&:to_i)#Breaks the input from a string into an array.
				@x = siz[0] #Stores the array in two values, x and y.
				@y = siz[1]
			elsif #There is only one number, therefore use it as both coordinates.
				@x = siz.to_i
				@y = siz.to_i
			end
		end
		@x = @maxx - 1 if @x >= @maxx #Set max and min
		@x = 5 if @x <= 4
		@y = @maxy - 1 if @y >= @maxy
		@y = 5 if @y <= 4
		@board = Array.new(@y) {Array.new(@x, @dead)}#Build the matrix.
		puts "Your Life Matrix will be #{@x} x #{@y}"
		show #Call show, which displays the Life Matrix to the user.
		puts "Would you like to activate wrapping?"
		puts "Wrapping will cause looping on the edges of the screen."
		puts "Yes default. N or No to deactivate."
		wrap = gets.chomp
		if ["n", "no"].include?(wrap)
			@wrapping = false
		else
			@wrapping = true
		end
		puts "Wrapping is #{@wrapping}.\n\n"
		puts "How many iterations? Leave blank for infinite."
		@its = gets.chomp.to_i
		puts "How long for each iteration? Leave blank for Medium.\n0.01 for very fast, 0.1 fast, 1 for medium, 3 for slow."
		@slp = gets.chomp.to_f
		if @slp == 0	#Verifies a valid number is given for delay.
			@slp = 1
		end
		@slp = 0.01 if @slp < 0.01
		@slp = 10 if @slp > 10
		coords
	end

	def tick #Where the magic happens! All the calculations.
		sleep(@slp)
		system "clear" or system "cls"
		@tboard = Array.new(@y) {Array.new(@x, "T")} #Set up a fake board to be used.
		ix = 0
		iy = 0
		while ((ix < @x) && (iy < @y)) #Check the rules
			neighbor(ix, iy) #Use coordinates to find how many neighbours a cell has.
			if (@board[iy][ix] == @live) && (@cnt < 2 || @cnt > 3)
				@tboard[iy][ix] = @dead
				# puts "	#{ix+1}, #{iy+1} has died!"
			elsif (@board[iy][ix] == @live) && (@cnt == 2 || @cnt == 3)
				@tboard[iy][ix] = @live
				# puts "	#{ix+1}, #{iy+1} has survived!"
			elsif (@board[iy][ix] == @dead) && @cnt == 3
				@tboard[iy][ix] = @live
				# puts "	#{ix+1}, #{iy+1} has begun life!"
			elsif (@board[iy][ix] == @dead) && @cnt != 3
				@tboard[iy][ix] = @dead
				# puts "	#{ix+1}, #{iy+1} remains in the grave."
			else
				puts "XXXXSomething has gone terribly wrong....XXXXX"
			end
			ix += 1

			if (ix == @x && iy == @y-1) #If every cell has been checked
				if @tboard == @copyb #If next cell board is the same as the previous (Not current) board
					@stable = true #Period 2 loop is occurring, so stop the program.
					# puts "The Life Matrix has stabilized."
				else
					@copyb = @board#Set previous board to current board.
				end
				if @board == @tboard #If current board is the same as future board
					@stable = true #Period 1 loop is occurring = perfectly stable.
				else
					@board = @tboard #Set current board to future board (Move to next iteration)
				end
			end


			if ix == @x && iy < @y# Check all x's in a row, then move to next column
				ix = 0
				iy += 1
			end
			@cnt = 0 #reset neighbors for the next cell to use
		end
		show
	end

	def neighbor(x1, y1) #Calculates how many live neighbours for each cell.
		#x1 is absolute (0-78) @x is relative (1-79)
		#xn is left of x1. xn = (x1 - 1)
		#xp is right of x1. xn = (x1 + 1)
		#@x is relative, so 1 greater than x1. (x1 + 1)
		#Testing to see if a wrap should happen or not
		if @wrapping == true
			if x1 == 0 #If x1 is 0, it's the very left column.
				xn = @x - 1 #xn needs to move one more, wrapping to the right side, or @x. That needs to be converted to abs, so -1.
			else #If x1 is any regular, non-left coordinate, check 1 space to the left.
				xn = x1 - 1 #x1 is absolute, so no need to convert. -1 will check the left.
			end
			if x1 == @x - 1#Convert @x to absolute, check to see if x1 is the right side.
				xp = 0#xp is moving right. If there is no right, wrap to absolute 0.
			else #Otherwise, xp moves right, or +1
				xp = x1 + 1 #Because x1 is absolute, no conversion is necessary.
			end
			if y1 == 0 #yn needs to move up, if 0; wrap
				yn = @y - 1 #Move to bottom-Conversion necessary
			else	#not on top, move up 1.
				yn = y1 - 1 #y1 is absolute, no conversion necessary
			end
			if y1 == @y - 1 #y1 needs to move down, test if on bottom already- convert @y to abs
				yp = 0 #Wrap back to top if y1 is at the bottom.
			else #Otherwise move down 1.
				yp = y1 + 1
			end
			@cnt += 1 if @board[yp][xn] == @live # Y+ X- re; -1,1 (1)
			@cnt += 1 if @board[yp][x1] == @live # Y+ X rel 0,1 (2)
			@cnt += 1 if @board[yp][xp] == @live # Y+ X+ rel 1,1 (3)
			@cnt += 1 if @board[y1][xn] == @live # Y X- rel -1, 0 (4)
			@cnt += 1 if @board[y1][xp] == @live # Y X+ rel 1, 0 (6)
			@cnt += 1 if @board[yn][xn] == @live # Y- X- rel -1, -1 (7)
			@cnt += 1 if @board[yn][x1] == @live # Y- X rel 0, -1 (8)
			@cnt += 1 if @board[yn][xp] == @live # Y- X+ rel 1, -1 (9)
			# 1/2/3
			# 4/5/6
			# 7/8/9
			# puts "#{@board[y1][x1]} has #{@cnt} neighbours at coordinate #{x1+1},#{y1+1}"
		else #If wrapping != true
			if x1 == 0 #moving left from 0 causes a non-cell, or wall.
				xn = nil #Set to nil, do not count neighbors.
			else
				xn = x1 - 1 #Otherwise move accordingly
			end
			if x1 == @x - 1 #Moving right outside wall
				xp = nil
			else
				xp = x1 + 1
			end
			if y1 == 0 #Moving up outside wall
				yn = nil
			else
				yn = y1 - 1
			end
			if y1 == @y - 1 #Moving down outside wall.
				yp = nil
			else
				yp = y1 + 1
			end
			if xn != nil #Do not check neighbours if nil, simply ignore.
				if yp != nil
					@cnt += 1 if @board[yp][xn] == @live # Y+ X- re; -1,1 (1)
				end
				@cnt += 1 if @board[y1][xn] == @live # Y X- rel -1, 0 (4)
				if yn != nil
					@cnt += 1 if @board[yn][xn] == @live # Y- X- rel -1, -1 (7)
				end
			end
			if xp != nil
				if yp != nil
					@cnt += 1 if @board[yp][xp] == @live # Y+ X+ rel 1,1 (3)
				end
				@cnt += 1 if @board[y1][xp] == @live # Y X+ rel 1, 0 (6)
				if yn != nil
					@cnt += 1 if @board[yn][xp] == @live # Y- X+ rel 1, -1 (9)
				end
			end
			if yp != nil
				@cnt += 1 if @board[yp][x1] == @live # Y+ X rel 0,1 (2)
			end
			if yn != nil
				@cnt += 1 if @board[yn][x1] == @live # Y- X rel 0, -1 (8)
			end
			# 1/2/3
			# 4/5/6
			# 7/8/9
			# puts "#{@board[y1][x1]} has #{@cnt} neighbours at coordinate #{x1+1},#{y1+1}"
		end
	end

	def show #Displays the current Life Matrix.
		i = 0
		while i < @y #Create a loop
			puts @board[i].join #join causes only one set of arrays to be displayed horizontally, the rest are displayed regularly, or vertical.
			i += 1
		end
		(@x).times do print "  " end #Display the coordinate of the very bottom right cell.
		puts " x#{@x}, y#{@y} "
	end

	def switch_cell(x, y) #When called, changed specified cell from live to dead or vice versa
		while x >= @x
			x-= @x
		end
		while y >= @y
			y -= @y
		end
		while x < 0
			x += @x
		end
		while y < 0
			y += @y
		end

		if @board[y][x] == @live
			@board[y][x] = @dead
		elsif @board[y][x] == @dead
			@board[y][x] = @live
		end
	end
end

system "clear" or system "cls"
game = GoL.new
puts "Do you wish to adjust settings? \nAny key to skip. Y or yes for yes."
do_set = gets.chomp.downcase
if ["y", "yes"].include?(do_set)
	game.getsiz
else
	game.show
	game.coords
end
i = nil #Counter for iterations.
a = 0
while game.instance_variable_get(:@its) != i
	game.tick
	a += 1
	i += 1 if i != nil#Loops game until counter is complete.
	puts "Iterations: #{a}"
	if game.instance_variable_get(:@stable) == true
		puts "The grid has stabilized. Enter more coordinates to continue or press X to exit the program."
		game.coords
	end
end
puts "Operation complete! Thanks for playing! :D"
