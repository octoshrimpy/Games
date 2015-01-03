#cd C:\Ruby193\Scripts

def rst_scores()
	playersc = 0
	compsc = 0
	dro = 0
	i = 0

	puts "Welcome to Rock Paper Scissors!"
	while i != 1
		compatt = 0
		playeratt = 0

		puts "Type your selection to play. Type N to quit or Reset to reset scores."
		playeratt = gets.chomp.downcase.split("")
		system "clear" or system "cls"
		rock = (playeratt & "rock".split("")).length
		paper = (playeratt & "paer".split("")).length
		scissors = (playeratt & "scior".split("")).length
		break if playeratt.join == "n" || playeratt.join == "no" || playeratt.join == "x"
		if playeratt.join == "reset"
			rst_scores()
		elsif rock >= paper && rock >= scissors
			playeratt = 1
		elsif paper >= scissors
			playeratt = 2
		else
			playeratt = 3
		end

		compatt = rand(1..3)
		if compatt == playeratt
			puts  "      It's a draw!"
			dro += 1
		elsif (compatt == 1 && playeratt == 2) || (compatt == 2 && playeratt == 3)|| (compatt == 3 && playeratt == 1)
			puts  "       You win!"
			playersc += 1
		elsif (compatt == 2 && playeratt == 1) || (compatt == 3 && playeratt == 2)|| (compatt == 1 && playeratt == 3)
			puts  "       You lose!"
			compsc += 1
		end

		compatt = case compatt
			when 1 then "Rock"
			when 2 then "Paper"
			when 3 then "Scissors"
		end

		playeratt = case playeratt
			when 1 then "Rock"
			when 2 then "Paper"
			when 3 then "Scissors"
		end

		puts "You played #{playeratt}. The opponent played #{compatt}."
		print "The score is #{playersc}-#{compsc} and "
		if dro == 1
			puts "there has been 1 draw."
		else
			puts "there have been #{dro} draws."
		end
	end

end

rst_scores()
