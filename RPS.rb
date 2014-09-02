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

		puts "\n\nType your selection to play. Type N to quit or Reset to reset scores."
		playeratt = gets.chomp.downcase
		if ["r", "rock"].include?(playeratt)
			playeratt = 1
		elsif [ "p", "paper"].include?(playeratt)
			playeratt = 2
		elsif ["s", "scissors"].include?(playeratt)
			playeratt = 3
		elsif ["n", "no"].include?(playeratt)
			i = 1
		elsif ["reset"].include?(playeratt)
			rst_scores()
		else puts "\n\nInvalid Statement"
		end

		break if i == 1

		compatt = rand(1..3)
		puts "\n\n"
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