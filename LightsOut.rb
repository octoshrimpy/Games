#cd C:\Ruby193\Scripts

# cond ? T : F
class Darkness

	def initialize
		@siz = 10
		@well = false
		@board = Array.new(@siz) {Array.new(@siz, ". ")}
		#Array.new(10) {Array.new(10, ". ")}
	end

	def click_cell(x, y)
		switch_cell(x+1, y) if (x+1) < @siz
		switch_cell(x-1, y) if (x-1) >= 0
		switch_cell(x, y)
		switch_cell(x, y+1) if (y+1) < @siz
		switch_cell(x, y-1) if (y-1) >= 0
	end

	def switch_cell(x, y)
		if (x < @siz) && (y < @siz) && (x >= 0) && (y >= 0)
			if @board[y][x] == ". "
				@board[y][x] = "O "
				# puts "#{x},#{y} changed!"
			elsif @board[y][x] == "O "
				@board[y][x] = ". "
				# puts "#{x},#{y} changed!"
			end
		end
	end

	def inp_coord
		puts " Type coordinates as two numbers separated by a space."
		c = gets.chomp.downcase
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
		return if (x > @siz) || (y > @siz) || (x < 0) || (y < 0)
		click_cell(x,y)
	end

	def show
		system "clear" or system "cls"
		i = 0
		puts "   0 1 2 3 4 5 6 7 8 9"
		while i < @siz
			print "#{i}  "
			puts @board[i].join
			i += 1
		end
	end

	def randomize
		i=0
		while i<50
			click_cell(rand(@siz),rand(@siz))
			i+=1
		end
	end

	def winn
		ix = 0
		iy = 0
		@well = false
		cnt = 0
		while ((ix < @siz) && (iy < @siz))
			if @board[iy][ix] == "O "
				# puts "Found O at #{ix}, #{iy}! Board still intact!"
				break
			elsif @board[iy][ix] == ". "
				# puts "#{ix}, #{iy} clean! Moving on..."
				ix += 1
			end
			if (ix == @siz) && (iy < @siz)
				ix = 0
				iy += 1
			elsif (ix == @siz - 1) && (iy == @siz - 1)
				puts "The board is all clean!"
				@well = true
				break
			end
		end
	end
end

game = Darkness.new
game.randomize
game.show
puts "Welcome to Lights out!"
while game.instance_variable_get(:@well) == false
	game.inp_coord
	game.winn
	game.show
end
puts "You win!!!"
