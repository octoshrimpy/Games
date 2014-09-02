#cd C:\Ruby193\Scripts

# cond ? T : F
class Calc
	def initialize
		@numf = 0
		@nums = 0
		@comput = 0
		@disp = 0
	end
	
	def fnum
		puts "Please enter your first number."
		puts "Enter X to retrieve previous answer."
		@numf = gets.chomp
		if @numf == "X"
			@numf = @disp
			puts "Successfully retrieved!"
		end
		@numf = @numf.to_f
		puts "\nYou have chosen #{@numf}\n\n"
	end
	
	def getc 
		puts "Please choose a number indicating a computation."
		puts "1 for addition (x + y), 2 for subtraction (x - y), "
		puts "3 for multiply (x * y), 4 for division (x / y),"
		puts "5 for root (y root of x (y = 2 for square root, y = 3 for cube)), "
		puts "6 for exponent (x to the power of y)."
		@comput = gets.chomp.to_i
		unless @comput >= 1 && @comput <= 6
			puts "Invalid statement."
			@disp = "Error: No computation possible."
			return
		else
			temp = case @comput
				when 1 then " plus "
				when 2 then " minus "
				when 3 then " multiplied by "
				when 4 then " divided by "
				when 5 then " to the root of "
				when 6 then " raised by the power of "
			end
			puts "\n\nYou have selected:\n #{@numf}#{temp}#{@nums}"
		end
	end

	def snum
		puts "Please enter your second number."
		puts "Enter X to retrieve previous answer."
		@nums = gets.chomp
		if @nums == "X"
			@nums = @disp
			puts "Successfully retrieved!"
		end
		@nums = @nums.to_f
		puts "\nYou have chosen #{@nums}\n\n"
	end
	
	def do_calc
		if @comput == 1
			@disp = @numf + @nums
		elsif @comput == 2
			@disp = @numf - @nums
		elsif @comput == 3
			@disp = @numf * @nums
		elsif @comput == 4
			@disp = @numf / @nums
		elsif @comput == 5
			@disp = @numf ** (1.00/@nums)
		elsif @comput == 6
			@disp = @numf ** @nums
		end
		puts "\nYour answer is: #{@disp}"
	end
end

i = 0
puts "\n\nWelcome to the Calculator!\n"
func = Calc.new
while i == 0
	func.fnum()
	func.snum()
	func.getc()
	func.do_calc()
	puts "Would you like to do another calculation? \n
		(Any key for yes, N or No for exit.)"
	ans = gets.chomp.downcase
	if ["n", "no"].include?(ans)
		i = 1
	end
end

