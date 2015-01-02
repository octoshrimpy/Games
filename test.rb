system "stty -raw echo"
File.new "./save.txt", "w+" if !(File.exists?("./save.txt"))
old = File.read("./save.txt").to_i
puts "The old high score is: #{old}"
puts "Please input a new score."
input = gets.chomp.to_i
new_score = input > old ? input : old.to_i
puts "#{new_score} is the new score"
File.open("./save.txt", 'w+') { |f| f.puts("#{new_score}") }
